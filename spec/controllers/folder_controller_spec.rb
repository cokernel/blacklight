require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'rubygems'
require 'marc'

describe FolderController do
    it "should add items to list" do
      params[:id] = "77826928"
      get :create
      params[:id] = "94120425"
      get :create
      session[:folder_document_ids].should include("77826928")
      session[:folder_document_ids].should include("94120425")
      session[:folder_document_ids].length.should == 2
      get :index
      @documents.length.should == 2
    end
end
