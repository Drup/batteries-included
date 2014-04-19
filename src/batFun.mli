(*
 * BatEnum - Enumeration over abstract collection of elements.
 * Copyright (C) 2003 Nicolas Cannasse
 *               2009 David Rajchenbach-Teller, LIFO, Universite d'Orleans
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version,
 * with the special exception on linking described in file LICENSE.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

(** General purpose combinators
    @author Simon Cruanes *)

val on : ('b -> 'b -> 'c) -> ('a -> 'b) -> 'a -> 'a -> 'c
(** [on f g x y] is [f (g x) (g y)]. Can be useful, for instance, to
    apply a comparator on a part of a type, say, [on compare snd]
    compares pairs by their second element. *)


external identity : 'a -> 'a = "%identity"
(** The identity function. *)

val undefined : ?message:string -> 'a -> 'b
  (** The undefined function.

      Evaluating [undefined x] always fails and raises an exception
      "Undefined". Optional argument [message] permits the
      customization of the error message.*)

 val ( @@ ) : ('a -> 'b) -> 'a -> 'b
 external ( @@ ) : ('a -> 'b) -> 'a -> 'b = "%apply"

(** Function application. [f @@ x] is equivalent to [f x].
    However, it binds less tightly (between [::] and [=],[<],[>],etc)
    and is right-associative, which makes it useful for composing sequences of
    function calls without too many parentheses. It is similar to Haskell's [$].
    Note that it replaces pre-2.0 [**>] and [<|]. *)

val ( % ) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
  (** Function composition: the mathematical [o] operator.
      [f % g] is [fun x -> f (g x)]. It is similar to Haskell's [.].

      Examples: the following are equivalent:
      [f (g (h x))], [f @@ g @@ h x], [f % g % h @@ x]. *)

 val ( |> ) : 'a -> ('a -> 'b) -> 'b
 external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply"
(** The "pipe": function application. [x |> f] is equivalent to [f x].

    This operator is commonly used to write a function composition by
    order of evaluation (the order used in object-oriented
    programming) rather than by inverse order (the order typically
    used in functional programming).

    For instance, [g (f x)] means "apply [f] to [x], then apply [g] to
    the result." The corresponding notation in most object-oriented
    programming languages would be somewhere along the lines of [x.f.g.h()],
    or "starting from [x], apply [f], then apply [g]." In OCaml,
    using the ( |> ) operator, this is written [x |> f |> g |> h].

    This operator may also be useful for composing sequences of
    function calls without too many parentheses. *)

val ( %> ) : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c
(** Piping function composition. [f %> g] is [fun x -> g (f x)].
    Whereas [f % g] applies [g] first and [f] second, [f @> g]
    applies [f], then [g].
    Note that it plays well with pipes, so for instance
    [x |> f %> g %> h |> i %> j] yields the expected result...
    but in such cases it's still recommended to use [|>] only.
    Note that it replaces pre-2.0 [|-], which {i didn't} integrate with
    pipes.
*)

val ( |? ) : 'a option -> 'a -> 'a
(** Like {!BatOption.default}, with the arguments reversed.
    [None |? 10] returns [10], while [Some "foo" |? "bar"] returns ["foo"].

    {b Note} This operator does not short circuit like [( || )] and [( && )].
    Both arguments will be evaluated.

    @since 2.0 *)

val flip : ( 'a -> 'b -> 'c ) -> 'b -> 'a -> 'c
(** Argument flipping.

    [flip f x y] is [f y x]. Don't abuse this function, it may shorten
    considerably your code but it also has the nasty habit of making
    it harder to read.*)


val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
(** Convert a function which accepts a pair of arguments into a
    function which accepts two arguments.

    [curry f] is [fun x y -> f (x,y)]*)

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
(** Convert a function which accepts a two arguments into a function
    which accepts a pair of arguments.

    [uncurry f] is [fun (x, y) -> f x y]*)

val neg : ('a -> bool) -> 'a -> bool
(** [neg p] returns a new predicate that is the negation of the given
    predicate.  That is, the new predicate returns [false] when the
    input predicate returns [true] and vice versa.  This is for
    predicates with one argument.

    [neg p] is [fun x -> not (p x)]
*)

val neg2 : ('a -> 'b -> bool) -> 'a -> 'b -> bool
(** as [neg] but for predicates with two arguments *)

val const : 'a -> (_ -> 'a)
(** Ignore its second argument.

    [const x] is the function which always returns [x].*)

val tap : ('a -> unit) -> 'a -> 'a
(** Allows application of a function in the middle of a pipe
    sequence without disturbing the sequence.  [x |> tap f]
    evaluates to [x], but has the side effect of [f x].  Useful for
    debugging. *)

val finally : (unit -> unit) -> ('a -> 'b) -> 'a -> 'b
(** [finally fend f x] calls [f x] and then [fend()] even if [f x] raised
    an exception. *)

val with_dispose : dispose:('a -> unit) -> ('a -> 'b) -> 'a -> 'b
(** [with_dispose dispose f x] invokes [f] on [x], calling [dispose x]
    when [f] terminates (either with a return value or an
    exception). *)

val forever : ('a -> 'b) -> 'a -> unit
(** [forever f x] invokes [f] on [x] repeatedly (until an exception occurs). *)

val ignore_exceptions : ('a -> 'b) -> 'a -> unit
(** [ignore_exceptions f x] invokes [f] on [x], ignoring both the returned value
    and the exceptions that may be raised. *)

val verify_arg : bool -> string -> unit
(** [verify_arg condition message] will raise [Invalid_argument message] if
    [condition] is false, otherwise it does nothing.

    @since 2.0 *)