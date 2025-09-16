#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99203 "PRL-13thSlip Payroll Periods"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99250;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Date Openned";"Date Openned")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Instalment";"Current Instalment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
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
                field("13thSlips Daily Rate";"13thSlips Daily Rate")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Instalments";"No. of Instalments")
                {
                    ApplicationArea = Basic;
                }
                field("Instalment Description";"Instalment Description")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Instalment Prefix";"Period Instalment Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("Closed By";"Closed By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No of Days";"No of Days")
                {
                    ApplicationArea = Basic;
                }
                field("Payslip Message";"Payslip Message")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ClosePeriod)
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
                      PayPeriod.Reset;
                      PayPeriod.SetRange(PayPeriod.Closed,false);
                    if PayPeriod.Find('-') then begin
                      objOcx.fnClosePayrollPeriod(PayPeriod."Date Openned",'13thSlip',PayPeriod."Current Instalment");
                      Message ('Process Complete');
                      end;
                    end else begin
                       Message('You have selected NOT to Close the period');
                    end

                end;
            }
            action(UpdateP9)
            {
                ApplicationArea = Basic;
                Caption = 'UpdateP9';

                trigger OnAction()
                begin
                    //IF NOT (Closed) THEN ERROR('The period is still open!');
                            if not (Confirm('Update P9 information for '+"Period Name"+'?')) then Error('Cancelled by user!');
                               Clear(objOcx);
                              objOcx.fnP9PeriodClosure("Period Month","Period Year","Date Openned",PayrollCode);
                              Message('P9 information for '+"Period Name"+' Successfully updated.');
                end;
            }
        }
    }

    var
        PayPeriod: Record UnknownRecord99250;
        strPeriodName: Text[30];
        Text000: label '''Leave without saving changes?''';
        Text001: label '''You selected %1.''';
        Question: Text[250];
        Answer: Boolean;
        objOcx: Codeunit "prPayrollProcessing 13thSlip";
        dtOpenPeriod: Date;
        PayrollType: Record UnknownRecord61103;
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record UnknownRecord61119;
        OpenInt: Integer;


    procedure fnGetOpenPeriod()
    begin
        Clear(OpenInt);
        //Get the open/current period
        PayPeriod.SetRange(PayPeriod.Closed,false);
        //PayPeriod.SETRANGE(date,Rec."Payroll Code");
        if PayPeriod.Find('-') then begin
          Validate(Closed);
           strPeriodName:=PayPeriod."Period Name";
           dtOpenPeriod:=PayPeriod."Date Openned";
           OpenInt:=PayPeriod."Current Instalment";
        end;
    end;
}

