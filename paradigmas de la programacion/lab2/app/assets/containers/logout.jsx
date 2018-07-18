import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

{/* Aqui manejamos la salida y el cierre de sesion de un user, desloggeandolo
  (a traves de una llamada a la api con axios) e eliminando los datos del local 
  storage. 
*/}

export default class Logout extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    axios
      .post("/api/logout")
      .then(
        response => {
          if (response.status == 200) {
            localStorage.removeItem('logged');
            localStorage.removeItem('logged_id');
            localStorage.removeItem('logged_type');
            this.props.history.push("/");
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

  render() {
    return null;
  }
}