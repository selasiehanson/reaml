module R = Reaml

module WindowSize = struct
  type t = {
    width : float;
    height : float;
  }

  external innerWidth : float = "innerWidth" [@@bs.val] [@@bs.scope "window"]
  external innerHeight : float = "innerHeight" [@@bs.val] [@@bs.scope "window"]

  external addEventListener : string -> (unit -> unit) -> unit = "addEventListener"
    [@@bs.val] [@@bs.scope "window"]

  external removeEventListener : string -> (unit -> unit) -> unit = "removeEventListener"
    [@@bs.val] [@@bs.scope "window"]

  let[@reaml.hook] use () =
    let[@reaml] size, setSize = R.useState { width = innerWidth; height = innerHeight } in
    let[@reaml] () =
      R.useEffect
        (fun () ->
          let handler () = setSize { width = innerWidth; height = innerHeight } in
          addEventListener "resize" handler;
          Some (fun () -> removeEventListener "resize" handler))
        None
    in
    size
end

module Demo = struct
  let[@reaml.component "Demo"] make () =
    let[@reaml] windowSize = WindowSize.use () in
    R.div [] [ R.float windowSize.width; R.string {j|×|j}; R.float windowSize.height ]
end

let () = Demo.make () |> R.renderTo "main"
