//
//  SurveyViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 01/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    @IBOutlet private var questionLabel: UILabel! {
        didSet {
            questionLabel.font = FontFamily.Montserrat.bold.font(size: 28)
            questionLabel.textColor = Asset.Colors.grayDark.color
            questionLabel.numberOfLines = 0
            questionLabel.textAlignment = .center
        }
    }

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.register(SurveyTableViewCell.nib(), forCellReuseIdentifier: SurveyTableViewCell.identifier)
        }
    }

    @IBOutlet private var actionButton: ActionButton! {
        didSet {
            actionButton.isEnabled = false
        }
    }

    var viewModel: SurveyViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.updateView()
    }
}

// MARK: - Button Action
private extension SurveyViewController {

    @IBAction func nextButtonPressed() {
        viewModel?.actionButtonPressed()
    }

}

// MARK: - UITableViewDataSource
extension SurveyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfChoices ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.identifier, for: indexPath) as? SurveyTableViewCell
        let choice = viewModel?.choice(atIndex: indexPath.row)
        cell?.setupCell(choice: choice)
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension SurveyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectChoice(atIndex: indexPath.row)
    }

}

// MARK: - SurveyViewModelViewDelegate
extension SurveyViewController: SurveyViewModelViewDelegate {

    func surveyViewModel(_ surveyViewModel: SurveyViewModel, updateViewWith survey: SurveyViewModel.Survey) {
        questionLabel.text = survey.questions[surveyViewModel.questionIndex].prompt

        if surveyViewModel.questionIndex == survey.questions.count - 1 {
            actionButton.buttonStyle = .finish
        }

        if survey.surveyResponse.indices.contains(surveyViewModel.questionIndex) {
            actionButton.isEnabled = true
        }

        tableView.reloadData()
    }

}