import React, { useState } from 'react';
import './App.css';

function App() {
  const [name, setName] = useState();
  const [email, setEmail] = useState();
  const [msg, setMsg] = useState();

  const submit = (e: React.SyntheticEvent,) => {
    e.preventDefault();
    fetch("https://c63v02a6we.execute-api.eu-west-2.amazonaws.com/api/formdata", {
        method: 'POST',
        cache: 'no-cache',
        mode: 'no-cors',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic k9M5BKRGMslwylSiuKMlraG1gYkqZSWW74Uv9THX9obnKiuJ9M',
        },
        body: `{"name": "${name}", "email": "${email}", "msg": "${msg}"}`,
      }
    )
      .then(res => (res.ok ? res : Promise.reject(res)))
      .then(res => res.json())
  }

  return (
    <div className="App">
      <form onSubmit={submit}>
        <label>Name:
          <input name="Name" type="text" value={name} onChange={(e: any,) => setName(e.target.value)} />
        </label>
        <label>Email:
          <input name="Email" type="email" value={email} onChange={(e: any,) => setEmail(e.target.value)} />
        </label>
        <label>Message:
          <input name="Message" type="textarea" value={msg} onChange={(e: any,) => setMsg(e.target.value)} />
        </label>
        <button type="submit" name="submit">Submit</button>
      </form>
    </div>
  );
}

export default App;
