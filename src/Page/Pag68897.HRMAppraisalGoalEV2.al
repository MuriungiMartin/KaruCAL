#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68897 "HRM-Appraisal Goal EV 2"
{
    PageType = Document;
    SourceTable = UnknownTable61232;
    SourceTableView = where(Status=const(Approved));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Appraisal No";"Appraisal No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Supervisor;Supervisor)
                {
                    ApplicationArea = Basic;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Period";"Appraisal Period")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
            }
            part(SF;"PROC-Procurement Plan list")
            {
            }
            label(Control1102755019)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19043501;
                Style = Strong;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Send To Appraisee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send To Appraisee';

                    trigger OnAction()
                    begin
                        if Confirm('Do you want to send this Appraisal Form to  your Supervisor?',false) = true then begin
                           Status:=0;
                           Modify;
                           Message('%1','Process Completed')
                        end;
                    end;
                }
                action("Import Evaluation Areas")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Evaluation Areas';

                    trigger OnAction()
                    begin
                        HRAppraisalEvaluations.Reset;
                        HRAppraisalEvaluations.SetRange(HRAppraisalEvaluations."Employee No","Employee No");
                        HRAppraisalEvaluations.SetRange(HRAppraisalEvaluations.Category,HRAppraisalEvaluations.Category::"EMPLOYEE PERFORMANCE FACTOR");
                        if HRAppraisalEvaluations.Find('-') then
                        HRAppraisalEvaluations.DeleteAll;

                        //COPY EVALUATION AREA FOR ONE EMPLOYEE
                        HRAppraisalEvaluationAreas.Reset;
                        HRAppraisalEvaluationAreas.SetRange
                        (HRAppraisalEvaluationAreas."Categorize As",HRAppraisalEvaluationAreas."categorize as"::"EMPLOYEE PERFORMANCE FACTOR");
                        if HRAppraisalEvaluationAreas.Find('-') then
                        HRAppraisalEvaluationAreas.FindFirst;
                        begin
                             HRAppraisalEvaluations.Reset;
                                  repeat
                                      HRAppraisalEvaluations.Init;
                                      HRAppraisalEvaluations."Employee No":="Employee No";
                                      HRAppraisalEvaluations."Evaluation Code":=HRAppraisalEvaluationAreas.Code;
                                      HRAppraisalEvaluations."Sub Category":=HRAppraisalEvaluationAreas."Sub Category";
                                      HRAppraisalEvaluations.Group:=HRAppraisalEvaluationAreas.Group;
                                      HRAppraisalEvaluations.Category:=HRAppraisalEvaluationAreas."Categorize As";
                                      HRAppraisalEvaluations."Appraisal Period":="Appraisal Period";
                                      HRAppraisalEvaluations."Line No":=HRAppraisalEvaluationAreas."Line No";
                                      //HRAppraisalEvaluations."Line No":=HRAppraisalEvaluations."Line No"+1;
                                      HRAppraisalEvaluations.Insert();
                                  until HRAppraisalEvaluationAreas.Next=0;
                                 // HRAppraisalEvaluationAreas.FINDFIRST;
                        end;
                    end;
                }
            }
        }
    }

    var
        HRAppraisalEvaluationAreas: Record UnknownRecord61236;
        HRAppraisalEvaluations: Record UnknownRecord61235;
        HRAppraisalEvaluationsF: Page "HRM-Appraisal Evaluation Lines";
        Text19043501: label 'EMPLOYEE PERFORMANCE FACTORS ';
}

