require 'test_helper'

class CsuggestionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Csuggestion.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Csuggestion.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Csuggestion.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to csuggestion_url(assigns(:csuggestion))
  end

  def test_edit
    get :edit, :id => Csuggestion.first
    assert_template 'edit'
  end

  def test_update_invalid
    Csuggestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Csuggestion.first
    assert_template 'edit'
  end

  def test_update_valid
    Csuggestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Csuggestion.first
    assert_redirected_to csuggestion_url(assigns(:csuggestion))
  end

  def test_destroy
    csuggestion = Csuggestion.first
    delete :destroy, :id => csuggestion
    assert_redirected_to csuggestions_url
    assert !Csuggestion.exists?(csuggestion.id)
  end
end
