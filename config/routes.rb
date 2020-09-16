Rails.application.routes.draw do
  root 'application#authorized'

  get 'donors/:id/get_donations', to: 'donors#get_donations'
  get 'donors/:id/get_active_donations', to: 'donors#get_active_donations'
  patch 'donors/:id/updateStatus', to: 'donors#account_status_update'
  post 'donor_auth', to: 'donor_auth#create'
  post 'donors/create', to: 'donors#create'
  patch 'donors/:id/update', to: 'donors#update'
  post 'donors/scan', to: 'donors#scan_qr_code'

  post 'donations/create', to: 'donations#create'
  patch 'donations/:id/update', to: 'donations#update'
  post 'donations/:id/claim', to: 'donations#make_claim'
  get 'donations/active', to: 'donations#active'
  get 'donations/:donor_id/history_donations', to: 'donations#donations_history'

  get 'clients/:id/get_claims', to: 'clients#get_claims'
  get 'clients/:donorid/travel_times', to: 'clients#get_travel_times'
  post 'clients/client_auth', to: 'client_auth#create'
  post 'clients/create', to: 'clients#create'
  patch 'clients/:id/updateStatus', to: 'clients#account_status_update'
  post 'clients/:id/get_donations', to: 'clients#get_donations'
  patch 'clients/:id/update', to: 'clients#update'
  get 'clients/:id/claims_history', to: 'clients#claims_history'

  post 'admins/admin_auth', to: 'admin_auth#create'
  get 'admins/:id/get_new_clients', to: 'admins#get_new_clients'
  get 'admins/:id/get_new_donors', to: 'admins#get_new_donors'
  get 'admins/:id/get_donations_status', to: 'admins#get_donations_status';

  post 'claims/create', to: 'claims#create'
  patch 'claims/:id/update', to: 'claims#update'

  post 'password_resets/:user', to: 'password_resets#create'
  get 'password_resets/:user/:token', to: 'password_resets#edit'   
  patch 'password_resets/:user/:token', to: 'password_resets#update'

end
