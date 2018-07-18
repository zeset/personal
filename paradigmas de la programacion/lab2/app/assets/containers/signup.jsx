import React from 'react';
import axios from 'axios';
import RegisterForm from '../presentational/registerForm.jsx';
import { Navbar } from '../presentational/navbar.jsx';

{/* Aqui es donde se recopilan los datos obtenidos en registerForm, necesarios 
  para registrar a un usuario nuevo. 
*/}


export default class Signup extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      type: "consumers",
      locations: [],
      location: 0,
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    let change = {};
    change[event.target.name] = event.target.value;
    if (change[event.target.name] == '' && event.target.name !== 'location') {
      change[event.target.name] = null;
    }
    this.setState(change);
  }

  handleSubmit(event) {
    event.preventDefault();

    if (this.state.location === 0) {
      alert("Porfavor introduzca su barrio");
      return;
    }

    let params = [];
    if (this.state.type == "consumers") {
      params = {
        email: this.state.email,
        location: this.state.location,
        password: this.state.password,
      };
    } else {
      params = {
        store_name: this.state.store_name,
        email: this.state.email,
        location: this.state.location,
        max_delivery_range: this.state.max_delivery_range,
        password: this.state.password,
        max_delivery_distance: this.state.max_delivery_distance,
      };
    }

    axios
      .post("/api/" + this.state.type, params)
      .then(
        response => {
          if (response.status == 200) {
            this.props.history.push("/login");
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
        }
    );
  }

  componentDidMount() {
    if (localStorage.getItem('logged') == 'true') {
      if (localStorage.getItem('logged_type') == 'providers'){
        this.props.history.push("/profile");
      }
    }

    axios
      .get("/api/locations")
      .then(
        response => this.setState({locations: response.data})
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status !== 404)
            alert(error.response.data);
          else
            alert(error.response.statusText);
        }
      );
  }

  render() {
    return (
      <div>
      <Navbar logged={localStorage.getItem("logged")} />
      <RegisterForm type={this.state.type}
              handleChange={this.handleChange}
              handleSubmit={this.handleSubmit}
              locations={this.state.locations}
      />
      </div>
    );
  }
}