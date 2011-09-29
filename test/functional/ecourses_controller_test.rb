require 'test_helper'

class EcoursesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Ecourse.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Ecourse.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Ecourse.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to ecourse_url(assigns(:ecourse))
  end

  def test_edit
    get :edit, :id => Ecourse.first
    assert_template 'edit'
  end

  def test_update_invalid
    Ecourse.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Ecourse.first
    assert_template 'edit'
  end

  def test_update_valid
    Ecourse.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Ecourse.first
    assert_redirected_to ecourse_url(assigns(:ecourse))
  end

  def test_destroy
    ecourse = Ecourse.first
    delete :destroy, :id => ecourse
    assert_redirected_to ecourses_url
    assert !Ecourse.exists?(ecourse.id)
  end
end
