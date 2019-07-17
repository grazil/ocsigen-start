(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

(* Os_tips demo *)

open%shared Eliom_content.Html.F

(* Service for this demo *)
let%server service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["demo-tips"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

(* Make service available on the client *)
let%client service = ~%service

(* Name for demo menu *)
let%shared name () = [%i18n S.demo_tips]

(* Class for the page containing this demo (for internal use) *)
let%shared page_class = "os-page-demo-tips"

(* Here is an example of tip. Call this function while generating the
   widget concerned by the explanation it contains. *)
let%shared example_tip () =
  (* Have a look at the API documentation of module Os_tips for
     more options. *)
  Os_tips.bubble ()
    ~top:[%client 40 ] ~right:[%client 0 ]
    ~width:[%client 300 ] ~height:[%client 180 ]
    ~arrow:[%client `top 250 ]
    ~name:"example"
    ~content:[%client (fun _ ->
      Lwt.return
        Eliom_content.Html.F.[ p [%i18n example_tip]
                             ; p [%i18n look_module_tip]
                             ]) ]

(* Page for this demo *)
let%shared page () =
  (* Call the function defining the tip from the server or the client: *)
  let%lwt () = example_tip () in
  Lwt.return
    [ h1 [%i18n tips1]
    ; p [%i18n tips2 ~os_tips:[code [ txt "Os_tips" ]] ]
    ; p [%i18n tips3 ]
    ; p [%i18n tips4
          ~set_page:[a ~service:%%%MODULE_NAME%%%_services.settings_service
                       [%i18n tips5] ()]
        ]
    ]
