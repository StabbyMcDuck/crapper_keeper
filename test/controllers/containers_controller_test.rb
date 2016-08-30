require 'test_helper'

class ContainersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @container = containers(:one)
  end

  test "should get index" do
    get containers_url
    assert_response :success
  end

  test "should get new" do
    get new_container_url
    assert_response :success
  end

  test "should create container" do
    assert_difference('Container.count') do
      post containers_url, params: { container: { depth: @container.depth, description: @container.description, lft: @container.lft, name: @container.name, parent_id: @container.parent_id, rgt: @container.rgt, user_id: @container.user_id } }
    end

    assert_redirected_to container_url(Container.last)
  end

  test "should show container" do
    get container_url(@container)
    assert_response :success
  end

  test "should get edit" do
    get edit_container_url(@container)
    assert_response :success
  end

  test "should update container" do
    patch container_url(@container), params: { container: { depth: @container.depth, description: @container.description, lft: @container.lft, name: @container.name, parent_id: @container.parent_id, rgt: @container.rgt, user_id: @container.user_id } }
    assert_redirected_to container_url(@container)
  end

  test "should destroy container" do
    assert_difference('Container.count', -1) do
      delete container_url(@container)
    end

    assert_redirected_to containers_url
  end
end
