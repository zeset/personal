
import React from 'react';
import axios from 'axios';
import { Navbar } from '../presentational/navbar';
import ItemList from '../presentational/itemsList';
import OrderList from '../presentational/orderList';

{/*Aqui es donde definimos los perfiles de los usuarios. Posee funcionalidades
 como listado de ordenes, listado de items(para providers), implementados a
 partir de sus propios componentes. La informacion basica(correo electronico,
 balance de la cuenta) es manejada desde aqui. Se realizan varias llamadas a la 
 api obteniendo datos que se le enviaran luego a los componentes itemlist y 
 orderlist
*/}

export default class Profile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: '',
      balance: '',
      location: '',
      maxDeliveryDistance: '',
      storeName: '',
      orders: [],
      loggedId: localStorage.getItem('logged_id'),
      isProvider: false,
      itemName: '', 
      price: 0, 
      items: []
    };

    this.handleChangeName = this.handleChangeName.bind(this);
    this.handleChangePrice = this.handleChangePrice.bind(this);
    this.itemPost = this.itemPost.bind(this);
    this.itemRemove = this.itemRemove.bind(this);
    this.getItems = this.getItems.bind(this);
    this.getOrders = this.getOrders.bind(this);
    this.deliverOrder = this.deliverOrder.bind(this);

  }

  handleChangeName(event) {
    this.setState({itemName: event.target.value});
  }

  handleChangePrice(event) {
    this.setState({price: event.target.value});
  }

  getItems() {
    axios
      .get('/api/items', 
        {params: {provider: localStorage.getItem("logged_id")}})
      .then(
      response => this.setState({items: response.data})
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status !== 404)
            alert('404');
          else
            alert(error.response.statusText);
          }
      );
    this.forceUpdate();
  }

  getOrders(){
    axios
      .get('/api/orders', 
        {params: {user_id: localStorage.getItem("logged_id")}})
      .then(
        response => {
          this.setState({'orders': response.data });
        }
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status === 404)
            alert('404');
          else if (error.response.data && error.response.status === 400)
            alert('400');
          else
            alert(error.response.statusText);
        }
      );
      this.forceUpdate();
  }

  itemRemove(event){
    axios
      .post("/api/items/delete/"+event.target.value)
      .then(
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
      this.getItems();
  }

  itemPost() {
    axios
      .post('/api/items',{
        'name': this.state.itemName,
        'price': parseInt(this.state.price),
        'provider':parseInt(this.state.loggedId)
      }).then(
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status === 400)
            alert('400');
          else if (error.response.data && error.response.status === 404)
            alert('404');
          else if (error.response.data && error.response.status === 409)
            alert('409');
          else
            alert(error.response.statusText);
        }
      );

      this.getItems();
  }

  deliverOrder(event){
      axios.post('/api/deliver/'+event.target.value)
      .then(
        response => {
          this.setState({orderState: 'delivered'});
        }).catch(
          error => {
            if (!error.response)
              alert(error);
            else if (error.response.data 
              && error.response.status === 404)
              alert('404');
            else
              alert(error.response.statusText);
          }
        );
      this.getOrders();
    }

  componentDidMount() {

    if (localStorage.getItem('logged') != 'true') {
      this.props.history.push("/login");
    }

    if (localStorage.getItem('logged_type') == "providers") {
      this.state.isProvider = true;
    }

    this.getOrders();
    if (this.state.isProvider) {
      this.getItems();
    }

    var path = "/api/users/"+this.state.loggedId;

    axios
      .get(path)
      .then(
        response => this.setState({'email':response.data.email,
          'balance': response.data.balance
        })
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status === 404)
            alert('400');
          else if (error.response.data && error.response.status === 404)
            alert('404');
          else
            alert(error.response.statusText);
        }
      );
  }


  render() {
    return (
      <div className="body">
        <Navbar logged={localStorage.getItem("logged")} />
        <h1 className="display-4 text-center my-3">Perfil de Usuario</h1>   
        <ul>
          <li><strong>Correo Electrónico: </strong>{this.state.email}</li>
          <li><strong>Balance: </strong>$ {this.state.balance}</li>
        </ul>
        <h1 className="display-4 text-center my-3">Pedidos</h1> 
          <OrderList orders={this.state.orders}
                     deliverOrder={this.deliverOrder}
          />
        <ul>
        </ul>
        <ItemList isProvider={this.state.isProvider}
                  items={this.state.items} 
                  handleChangeName={this.handleChangeName} 
                  handleChangePrice={this.handleChangePrice}  
                  itemPost={this.itemPost}
                  itemRemove={this.itemRemove}
                  price={this.state.price}
                  itemName={this.state.itemName}
        />

      </div>
    );
  }
}