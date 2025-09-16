#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69176 "HRM-Institutions List"
{
    Caption = 'HR Setups';
    CardPageID = "HRM-Institutions";
    PageType = List;
    SourceTable = UnknownTable61828;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Institution Code";"Institution Code")
                {
                    ApplicationArea = Basic;
                }
                field("Institution Name";"Institution Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Company Setups")
            {
                Caption = '&Company Setups';
                Image = Capacities;
                action("Company Information")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Information';
                    Image = CompanyInformation;
                    Promoted = true;
                    RunObject = Page "Company Information";
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    RunObject = Page Dimensions;
                }
                action(Committees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Committees';
                    Image = AllLines;
                    Promoted = true;
                    RunObject = Page "HRM-Committees (C)";
                }
                action("Boad of Directores")
                {
                    ApplicationArea = Basic;
                    Caption = 'Boad of Directores';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "HRM-Board of Directors";
                }
                action("Rules && Regulations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rules && Regulations';
                    Image = RoutingVersions;
                    Promoted = true;
                    RunObject = Page "HRM-Rules & Regulations";
                }
                action("Base Calender Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calender Card';
                    Image = Calendar;
                    Promoted = true;
                    RunObject = Page "Base Calendar Card";
                }
                action("Posting Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Groups';
                    Image = PostingEntries;
                    Promoted = true;
                    RunObject = Page "HRM-Posting Groups";
                }
                action("Company Activities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Activities';
                    RunObject = Page "HRM-Company Activities";
                }
            }
            group(Staffing)
            {
                Caption = 'Staffing';
                Image = HRSetup;
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page Qualifications;
                }
                action(Grades)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grades';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HRM-Grades";
                }
            }
            group("Employee Manager Setups")
            {
                Caption = 'Employee Manager Setups';
                Image = HumanResources;
                action("Contract Types")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Types';
                    Image = TestDatabase;
                    Promoted = true;
                    RunObject = Page "HRM-Contract Types";
                }
                action("Ethnic Communities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ethnic Communities';
                    Image = Components;
                    Promoted = true;
                    RunObject = Page "GEN-Ethnic Communities";
                }
                action(Designation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Designation';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HRM-Staff Tiltles";
                }
                action("Causes of Absence")
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Absence';
                    RunObject = Page "Causes of Absence";
                }
                action("Causes of Inactivity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                }
                action("Grounds for Termination")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                }
                action("Employment Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                }
                action(Action25)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    RunObject = Page Qualifications;
                }
                action("Misc. Articles")
                {
                    ApplicationArea = Basic;
                    Caption = 'Misc. Articles';
                    RunObject = Page "Vendor Card";
                }
                action(Confidential)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                }
                action("Training Sources")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Sources';
                    RunObject = Page "HRM-Training Sources";
                }
            }
            group("Leave Management Setups")
            {
                Caption = 'Leave Management Setups';
                Image = Intrastat;
                action("Leave Types")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Types';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "HRM-Leave Types";
                }
                action(Hollidays)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hollidays';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HRM-Holidays";
                }
                action("Base Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Base Calendar Card";
                }
                action("Leave Family Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Family Groups';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HRM-Leave Family Groups";
                }
            }
            group("Disciplinary Setups")
            {
                Caption = 'Disciplinary Setups';
                Image = Reconcile;
                action("Disciplinary Case Ratings")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Case Ratings';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "HRM-Disciplinary Case Ratings";
                }
                action("Disciplinary Remarks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Remarks';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "HRM-Disciplinary Remarks";
                }
                action("Disciplinary  Cases")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary  Cases';
                    Image = SetPriorities;
                    Promoted = true;
                    RunObject = Page "HRM-Disciplinary Cases (B)";
                }
                action("Disciplinary Actions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disciplinary Actions';
                    Image = AccountingPeriods;
                    Promoted = true;
                    RunObject = Page "HRM-Disciplinary Actions";
                }
            }
            group("Appraisal Setups")
            {
                Caption = 'Appraisal Setups';
                Image = Setup;
                action("Appraisal types")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal types';
                    Image = Trendscape;
                    Promoted = true;
                    RunObject = Page "HRM-Appraisal Types";
                }
                action("Appraisal Periods")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Periods';
                    Image = PeriodStatus;
                    Promoted = true;
                    RunObject = Page "HRM-Appraisal Periods";
                }
                action("Appraisal Ratings")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Ratings';
                    Image = ReceiveLoaner;
                    Promoted = true;
                    RunObject = Page "HRM-Appraisal Ratings (B)";
                }
            }
            group("Trainning Management")
            {
                Caption = 'Trainning Management';
                Image = Statistics;
                action("Trainning Programmes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trainning Programmes';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "FIN-Staff Advance List";
                }
                action("External Trainers")
                {
                    ApplicationArea = Basic;
                    Caption = 'External Trainers';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Vendor Card";
                }
            }
            group("General Setups")
            {
                Caption = 'General Setups';
                Image = LotInfo;
                action("HR Setups")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Setups';
                    RunObject = Page "HRM-Setup";
                }
                action("Interaction Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Groups';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page "Interaction Groups";
                }
                action("Interaction Templates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Templates';
                    Image = Group;
                    Promoted = true;
                    RunObject = Page "Interaction Templates";
                }
                action("Interaction Salutations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Salutations';
                    Image = QualificationOverview;
                    Promoted = true;
                    RunObject = Page Salutations;
                }
                action("Templates Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Templates Setup';
                    Image = Template;
                    Promoted = true;
                    RunObject = Page "Interaction Template Setup";
                }
                action("Recruitment Stages")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recruitment Stages';
                    Image = Stages;
                    Promoted = true;
                    RunObject = Page "HRM-Recruitment stages";
                }
            }
        }
    }
}

