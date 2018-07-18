import React from 'react';
import LoginForm from  '../presentational/loginForm.jsx';
import { Navbar } from '../presentational/navbar.jsx';
import axios from 'axios';

{/* Aqui es donde se maneja el inicio de sesion de un usuario, ya sea un
    consumer o un provider, dado por los datos recopilados en el login form
*/}

export default class Login extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      email: null,
      password: null,
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    let change = {};
    change[event.target.name] = event.target.value;
    this.setState(change);
  }

  handleSubmit(event) {
    event.preventDefault();

    let user = {
      email: this.state.email,
      password: this.state.password,
    };

    axios
      .post("/api/login", user)
      .then(
        response => {
          if (response.status == 200) {
            localStorage.setItem("logged", "true");
            localStorage.setItem("logged_id", response.data.id);
            if (response.data.isProvider) {
              let type = "providers";
              localStorage.setItem("logged_type", type);
              this.props.history.push("/profile");
            } else {
              let type = "consumers";
              localStorage.setItem("logged_type", type);
              this.props.history.push("/");
            }
          }
        }
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status !== 404)
            alert(error.response.data);
          else
            alert(error.response.statusText);
          this.setState({loading: false});
        }
      );
  }

  componentDidMount(){
    if (localStorage.getItem("logged") == "true") {
      alert("Usted ya esta logeado.");
      this.props.history.push("/");
    }
  }

  render() {
    return (
      <div>
      <Navbar logged={localStorage.getItem("logged")}/>
      <LoginForm
        handleChange={this.handleChange}
        handleSubmit={this.handleSubmit}
      />
      </div>
    );
  }

}
