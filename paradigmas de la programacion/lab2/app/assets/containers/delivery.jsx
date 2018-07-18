import queryString from 'query-string'
import React from 'react';
import PropTypes from 'prop-types';
import { Navbar } from '../presentational/navbar';
import axios from 'axios';
import ProvidersList from '../presentational/providersList';

{/* Aqui es donde se recopilan los providers, sobre el cual luego se podran
  realizar las ordenes. Tomamos parametros enviados por el usuario a traves de
  URL. Utilizamos estos datos para obtener informacion de la api sobre los 
  proveedores disponibles en la zona del usuario.
*/}

export default class Delivery extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      providers: []
    };

  }

  componentDidMount() {

    if (localStorage.getItem('logged') == 'true') {
      if (localStorage.getItem('logged_type') == 'providers'){
        this.props.history.push("/profile");
      }
    } else {
      if (localStorage.getItem('logged_type') == 'providers'){
        this.props.history.push("/profile");
      } else {
        this.props.history.push("/");
      }
    }

  	const usr_Params = queryString.parse(this.props.location.search);

    axios
      .get('/api/providers', {params: {location: usr_Params.location}})
      .then(
        response => this.setState({providers: response.data})
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status !== 400)
            alert('400');
          else if (error.response.data && error.response.status !== 409)
            alert('409');
          else
            alert(error.response.statusText);
        }
      );
  }

  render() {
    return (
    	<div>
    		<Navbar logged={localStorage.getItem("logged")}/>
    		<ProvidersList providers={this.state.providers}/>
    	</div>
    );
  }
}
