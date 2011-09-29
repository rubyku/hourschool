require 'test_helper'

class EsuggestionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Esuggestion.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Esuggestion.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Esuggestion.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to esuggestion_url(assigns(:esuggestion))
  end

  def test_edit
    get :edit, :id => Esuggestion.first
    assert_template 'edit'
  end

  def test_update_invalid
    Esuggestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Esuggestion.first
    assert_template 'edit'
  end

  def test_update_valid
    Esuggestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Esuggestion.first
    assert_redirected_to esuggestion_url(assigns(:esuggestion))
  end

  def test_destroy
    esuggestion = Esuggestion.first
    delete :destroy, :id => esuggestion
    assert_redirected_to esuggestions_url
    assert !Esuggestion.exists?(esuggestion.id)
  end
end
