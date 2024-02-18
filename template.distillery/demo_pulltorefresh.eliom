(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

(** Demo for refreshable content *)

[%%shared open Eliom_content.Html]
[%%shared open Eliom_content.Html.D]

let%shared page () =
  let counter_sig, set_counter = Eliom_shared.React.S.create 0 in
  let reload =
    [%client
      fun () ->
        let%lwt _ = Js_of_ocaml_lwt.Lwt_js.sleep 1. in
        let n = Eliom_shared.React.S.value ~%counter_sig in
        ~%set_counter (n + 1);
        Lwt.return_true]
  in
  let counter_node_sig =
    Eliom_shared.React.S.map
      [%shared
        fun n ->
          let n = [F.txt @@ string_of_int n] in
          F.p [%i18n Demo.pull_to_refresh_counter ~n]]
      counter_sig
  in
  let content =
    F.div
      ~a:[F.a_class ["demo-pull-to-refresh-content"]]
      [ F.h1 [%i18n Demo.pull_to_refresh]
      ; F.p [%i18n Demo.pull_to_refresh_1]
      ; F.p [%i18n Demo.pull_to_refresh_2]
      ; R.node counter_node_sig ]
  in
  Lwt.return @@ [Ot_pulltorefresh.make ~dragThreshold:15. ~content reload]

(* Service registration is done on both sides (shared section),
   so that pages can be generated from the server
   (first request, crawling, search engines ...)
   or the client (subsequent link clicks, or mobile app ...). *)
let%shared () =
  %%%MODULE_NAME%%%_base.App.register ~service:Demo_services.demo_pulltorefresh
    ( %%%MODULE_NAME%%%_page.Opt.connected_page @@ fun myid_o () () ->
      let%lwt p = page () in
      %%%MODULE_NAME%%%_container.page ~a:[a_class ["os-page-demo-pulltorefresh"]] myid_o p
    )
