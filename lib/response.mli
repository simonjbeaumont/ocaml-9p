(*
 * Copyright (C) 2015 David Scott <dave@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

(** Parsers and printers for 9P response messages *)

open Sexplib
open Types
open Result

module Version : sig

  type t = {
    msize: int32;    (** the server's maximum message size, must be less than the client's *)
    version: Types.Version.t;
  } with sexp
  (** The payload of a version message *)

  include S.SERIALISABLE with type t := t
end

module Auth : sig

  type t = {
    aqid: Qid.t;
  } with sexp
  (** The payload of an authentication response *)

  include S.SERIALISABLE with type t := t
end

module Err : sig

  type t = {
    ename: string;
    errno: int32 option; (** The extended 9P2000.u protocol allows the server to return an errno *)
  } with sexp
  (** The pauload of an error response *)

  include S.SERIALISABLE with type t := t
end

module Flush : sig
  type t = unit with sexp
  (** The payload of a flush response *)

  include S.SERIALISABLE with type t := t
end

module Attach : sig
  type t = {
    qid: Qid.t
  } with sexp
  (** The payload of an attach response *)

  include S.SERIALISABLE with type t := t
end

module Walk : sig
  type t = {
    wqids: Qid.t list
  } with sexp
  (** The payload of a walk response *)

  include S.SERIALISABLE with type t := t
end

module Open : sig
  type t = {
    qid: Qid.t;
    iounit: int32;
  } with sexp
  (** The payload of an Open response *)

  include S.SERIALISABLE with type t := t
end

module Create : sig
  type t = {
    qid: Qid.t;
    iounit: int32;
  } with sexp
  (** The payload of a Create response *)

  include S.SERIALISABLE with type t := t
end

module Read : sig
  type t = {
    data: Cstruct.t
  } with sexp
  (** The payload of a Read response *)

  include S.SERIALISABLE with type t := t
end

module Write : sig
  type t = {
    count: int32
  } with sexp
  (** The payload of a Write response *)

  include S.SERIALISABLE with type t := t
end

module Clunk : sig
  type t = unit with sexp
  (** The payload of a Clunk response *)

  include S.SERIALISABLE with type t := t
end

module Remove : sig
  type t = unit with sexp
  (** The payload of a Remove response *)

  include S.SERIALISABLE with type t := t
end

module Stat : sig
  type t = {
    stat: Stat.t;
  } with sexp
  (** The payload of a Stat response *)

  include S.SERIALISABLE with type t := t
end

module Wstat : sig
  type t = unit with sexp
  (** The payload of a Wstat response *)

  include S.SERIALISABLE with type t := t
end

type payload =
  | Version of Version.t
  | Auth of Auth.t
  | Err of Err.t
  | Flush of Flush.t
  | Attach of Attach.t
  | Walk of Walk.t
  | Open of Open.t
  | Create of Create.t
  | Read of Read.t
  | Write of Write.t
  | Clunk of Clunk.t
  | Remove of Remove.t
  | Stat of Stat.t
  | Wstat of Wstat.t
with sexp
(** A variant including all possible 9P response payloads *)

type t = {
  tag: Types.Tag.t; (** The tag used to match this response with the original request *)
  payload: payload;
} with sexp
(** A 9P protocol response *)

include S.SERIALISABLE with type t := t

val to_string: t -> string
