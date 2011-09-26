require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Course.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Course.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Course.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to course_url(assigns(:course))
  end

  def test_edit
    get :edit, :id => Course.first
    assert_template 'edit'
  end

  def test_update_invalid
    Course.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Course.first
    assert_template 'edit'
  end

  def test_update_valid
    Course.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Course.first
    assert_redirected_to course_url(assigns(:course))
  end

  def test_destroy
    course = Course.first
    delete :destroy, :id => course
    assert_redirected_to courses_url
    assert !Course.exists?(course.id)
  end
end
