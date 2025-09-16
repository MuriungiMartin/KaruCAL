#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68060 "PRL-Payroll Periods"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61081;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Year";"Period Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Opened";"Date Opened")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payroll Code";"Payroll Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Allow View of Online Payslips";"Allow View of Online Payslips")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Online';
                }
                field("PayPeriod.""Approval Comments""";PayPeriod."Approval Comments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Comments';
                }
                field("PayPeriod.""Approved For Closure""";PayPeriod."Approved For Closure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved';
                    Editable = false;
                }
                field("PayPeriod.""Approved By""";PayPeriod."Approved By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved by';
                    Editable = false;
                }
                field("PayPeriod.""Approved Date""";PayPeriod."Approved Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved date';
                    Editable = false;
                }
                field("PayPeriod.""Approved Time""";PayPeriod."Approved Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Time';
                    Editable = false;
                }
                field("Payslip Message";"Payslip Message")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payslip message';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ApproveClosure)
            {
                ApplicationArea = Basic;
                Caption = 'Approve Closure';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    usersteup: Record "User Setup";
                begin
                    if not ApprovePayroll then Error('You do NOT have permission to Approve Closure OF Payroll');
                    PayPeriod.Reset;
                    PayPeriod.SetRange(Closed,false);
                    if PayPeriod.Find('-') then begin
                     /// IF PayPeriod."Approval Comments"='' THEN ERROR('Please Provide Approval Comments');
                    PayPeriod."Approved By":=UserId;
                    PayPeriod."Approved Date":=Today;
                    PayPeriod."Approved For Closure":=true;
                    PayPeriod."Approved Time":=Time;
                    PayPeriod.Modify;
                    end;
                end;
            }
            action("Close Period")
            {
                ApplicationArea = Basic;
                Caption = 'Close Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*
                    Warn user about the consequence of closure - operation is not reversible.
                    Ask if he is sure about the closure.
                    */
                    
                    fnGetOpenPeriod;
                    
                    Question := 'Once a period has been closed it can NOT be opened.\It is assumed that you have PAID out salaries.\'
                    + 'Do still want to close ['+ strPeriodName +']';
                    
                    //For Multiple Payroll
                    ContrInfo.Get();
                    if ContrInfo."Multiple Payroll" then begin
                    PayrollDefined:='';
                    PayrollType.SetCurrentkey(EntryNo);
                    if PayrollType.FindFirst then begin
                        NoofRecords:=PayrollType.Count;
                        repeat
                          i+= 1;
                          PayrollDefined:=PayrollDefined+'&'+PayrollType."Payroll Code";
                          if i<NoofRecords then
                             PayrollDefined:=PayrollDefined+','
                        until PayrollType.Next=0;
                    end;
                    
                    
                            Selection := StrMenu(PayrollDefined,3);
                            PayrollType.Reset;
                            PayrollType.SetRange(PayrollType.EntryNo,Selection);
                            if PayrollType.Find('-') then begin
                                PayrollCode:=PayrollType."Payroll Code";
                            end;
                    end;
                    //End Multiple Payroll
                    
                    
                    
                    Answer := Dialog.Confirm(Question, false);
                    if Answer=true then
                    begin
                      Clear(objOcx);
                      objOcx.fnClosePayrollPeriod(dtOpenPeriod,PayrollCode);
                      Message ('Process Complete');
                    end else begin
                       Message('You have selected NOT to Close the period');
                    end

                end;
            }
            action(updateP9)
            {
                ApplicationArea = Basic;
                Caption = 'Update P9 Data';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                           if not (Closed) then Error('The period is still open!');
                            if not (Confirm('Update P9 information for '+"Period Name"+'?')) then Error('Cancelled by user!');
                               Clear(objOcx);
                              objOcx.fnP9PeriodClosure("Period Month","Period Year","Date Opened","Payroll Code");
                              Message('P9 information for '+"Period Name"+' Successfully updated.');
                end;
            }
        }
    }

    var
        PayPeriod: Record UnknownRecord61081;
        strPeriodName: Text[30];
        Text000: label '''Leave without saving changes?''';
        Text001: label '''You selected %1.''';
        Question: Text[250];
        Answer: Boolean;
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        dtOpenPeriod: Date;
        PayrollType: Record UnknownRecord61103;
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record UnknownRecord61119;


    procedure fnGetOpenPeriod()
    begin

        //Get the open/current period
        PayPeriod.SetRange(PayPeriod.Closed,false);
        if PayPeriod.Find('-') then begin
          Validate(Closed);
           strPeriodName:=PayPeriod."Period Name";
           dtOpenPeriod:=PayPeriod."Date Opened";
        end;
    end;
}

