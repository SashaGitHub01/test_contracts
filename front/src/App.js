import logo from "./logo.svg";
import "./App.css";
import { useEffect, useLayoutEffect, useState } from "react";

function App() {
  const [num, setNum] = useState(0);

  console.log("render"); // 1

  useLayoutEffect(() => { // 4
    console.log("layout effect");
    return () => console.log("cleanup layout effect");
  }, [num]);

  useEffect(() => { // 6
    console.log("effect");

    return () => console.log("cleanup effect");
  }, [num]);

  return (
    <div className="App">
      <Child num={num} />
      <button onClick={() => setNum((n) => n + 1)}>rerender</button>
    </div>
  );
}

export default App;

const Child = ({ num }) => {
  console.log("child :: render"); // 2

  useLayoutEffect(() => { // 3
    console.log("child :: layout effect");
    return () => console.log("child :: cleanup layout effect");
  }, [num]);

  useEffect(() => { // 5
    console.log("child :: effect");

    return () => console.log("child :: cleanup effect");
  }, [num]);

  return <div>childje {num}</div>;
};
