# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DailyReportController do
  login_user

  before(:all) do
    FG.create(:Employee)
    FG.create(:SysConfig_test001)
  end

  describe DailyReportController do
    describe '順次テスト' do

      before(:all) do
        self.use_transactional_fixtures = false
      end

      after(:all) do
        self.use_transactional_fixtures = true
      end

      describe '日報' do

        before(:each) do
          get :list, :date => '2014-01'
        end

        it '初回表示時にはidがないDaily_reportを取得する' do
          expect(response).to be_success
          expect(response).to render_template("list")

          expect(assigns(:preview_date)).to eq('2013-12')
          expect(assigns(:next_date)).to eq('2014-02')
          expect(assigns(:target_daily_reports)[0].id).to be_nil
          expect(assigns(:target_daily_reports)[0].report_date).to eq(Date.new(2014, 1, 1))
          expect(assigns(:target_daily_reports)).to have(31).items
        end

        it '取得したレポートをUpdateで更新する' do
          target_daily_report = assigns(:target_daily_reports)
          target_data = Hash.new

          0.upto(target_daily_report.size - 1) do |number|
            target_daily_report[number].succeeds = 1
            target_daily_report[number].gross_profits = 2
            target_daily_report[number].interviews = 3
            target_daily_report[number].new_meetings = 4
            target_daily_report[number].exist_meetings = 5
            target_data[number.to_s] = target_daily_report[number].attributes
          end

          post :update, {:target_daily_report => target_data, :date => '2014-01'}
          expect(response).to redirect_to(:action => 'list', :date => '2014-01')
        end

        it '年月を指定していなくても取得できる' do
          get :list
          expect(response).to be_success
          expect(response).to render_template("list")
        end
      end

      describe '日報集計' do
        before(:each) do
          get :summary
        end

        it '年次で取得する' do
          expect(response).to be_success
          expect(response).to render_template("summary")

          post :summary, {:summary_term_flg => 'year', :summary_target_flg => nil, :summary_method_flg => 'individual'}
          expect(response).to be_success
          expect(response).to render_template("summary")
          expect(session[:daily_report_summary]).not_to be_nil
        end

        it '月次で取得する' do
          post :summary, {:summary_term_flg => 'month', :summary_target_flg => nil, :summary_method_flg => 'individual'}
          expect(response).to be_success
          expect(response).to render_template("summary")
          expect(session[:daily_report_summary]).not_to be_nil
        end

        it '日次で取得する' do
          post :summary, {:summary_term_flg => 'day', :summary_target_flg => nil, :summary_method_flg => 'individual'}
          expect(response).to be_success
          expect(response).to render_template("summary")
          expect(session[:daily_report_summary]).not_to be_nil
        end

        it 'clearボタンを押すと内容がクリアされる' do
          post :summary, {:summary_term_flg => 'year', :summary_target_flg => nil, :summary_method_flg => 'individual'}
          expect(response).to be_success
          expect(response).to render_template("summary")

          post :summary, {:clear_button => true}

          expect(session[:daily_report_summary]).to eq({})
        end
      end
    end
  end
end
