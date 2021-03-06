module R = Reaml

module Clicks = struct
  type action = Clicked of int * int

  let reducer state = function
    | Clicked (x, y) -> (x, y) :: state

  let[@reaml.component "Clicks"] make () =
    let[@reaml] state, dispatch = R.useReducer reducer [] in
    R.div
      [
        R.Attr.list
          R.Style.
            [
              height "400px";
              padding "1rem";
              background "#fefcbf";
              border "2px dashed #F6E05E";
              borderRadius "4px";
              overflow "scroll";
              marginBottom "2rem";
              userSelect "none";
            ];
        R.onClick (fun event ->
            dispatch R.Event.Mouse.(Clicked (clientX event, clientY event)));
      ]
      [
        R.h1 [] [ R.string "Click Anywhere!" ];
        R.div []
          [
            R.ul []
              (state |. Belt.List.map (fun (x, y) -> R.li [] [ R.string {j|$x × $y|j} ]));
          ];
      ]
end

let main = R.div [] [ Clicks.make () ]
let () = main |> R.renderTo "main"
