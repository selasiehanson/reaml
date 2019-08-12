module R = Reaml;

let useDoubleReducer =
  [@reaml.hook]
  (
    ((reducer, initialValue)) => {
      let [@reaml] (state, dispatch) = R.useReducer(reducer, initialValue);
      let dispatchTwice = action => {
        dispatch(action);
        dispatch(action);
      };
      (state, dispatchTwice);
    }
  );

let make =
  [@reaml.component "CustomHooks"]
  (
    () => {
      let reducer = (state, action) => state + action;
      let [@reaml] (state, dispatch) = useDoubleReducer((reducer, 0));
      R.button([R.onClick(_ => dispatch(1))], [R.int(state)]);
    }
  );

let main = make();
switch (R.find("main")) {
| Some(element) => R.render(main, element)
| None => Js.Console.error("<main> not found!")
};
