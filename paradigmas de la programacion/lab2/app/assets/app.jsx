import React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import Main from './containers/main';
import NotFound from './presentational/notfound';
import Profile from './containers/profile';
import Login from './containers/login';
import Signup from './containers/signup';
import Delivery from './containers/delivery';
import Logout from './containers/logout';
import Menu from './containers/menu';


export default function App() {
  return (
    <BrowserRouter>
      <Switch>
        <Route exact path="/" component={Main} />
        <Route exact path="/login" component={Login}/>
        <Route exact path="/logout" component={Logout}/>
        <Route exact path="/signup" component={Signup}/>
        <Route exact path="/profile" component={Profile}/>
        <Route exact path="/delivery" component={Delivery}/>
        <Route exact path="/menu" component={Menu}/>
        <Route component={NotFound}/>
      </Switch>
    </BrowserRouter>
  );
}
