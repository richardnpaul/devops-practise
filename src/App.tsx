import React, { useState } from 'react';
import './App.css';

function App() {
  const [name, setName] = useState();
  const [email, setEmail] = useState();
  const [msg, setMsg] = useState();

  const submit = (e: React.SyntheticEvent,) => {
    e.preventDefault();
    fetch("/api/formdata/", {
        method: 'POST',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic k9M5BKRGMslwylSiuKMlraG1gYkqZSWW74Uv9THX9obnKiuJ9M',
        },
        body: `{"name": "${name}", "email": "${email}", "message": "${msg}"}`,
      }
    )
      .then(res => (res.ok ? res : Promise.reject(res)))
      .then(res => res.json())
  }

  return (
    <div className="App">
      <form onSubmit={submit}>
        <label>Name:
          <input name="Name" type="text" value={name} onChange={() => setName(name)}/>
        </label>
        <label>Email:
          <input name="Email" type="email" value={email} onChange={() => setEmail(email)}/>
        </label>
        <label>Message:
          <input name="Message" type="textarea" value={msg} onChange={() => setMsg(msg)}/>
        </label>
        <button type="submit" name="submit">Submit</button>
      </form>
    </div>
  );
}

export default App;
