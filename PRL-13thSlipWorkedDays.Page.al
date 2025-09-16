#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99202 "PRL-13thSlip Worked Days"
{
    PageType = List;
    SourceTable = UnknownTable99200;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Days Worked";"Days Worked")
                {
                    ApplicationArea = Basic;
                }
                field("Daily Rate";"Daily Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Computed Days";"Computed Days")
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
                field("F.  Name";"F.  Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("M. Name";"M. Name")
                {
                    ApplicationArea = Basic;
                }
                field("L. Name";"L. Name")
                {
                    ApplicationArea = Basic;
                }
                field("Current Instalment";"Current Instalment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Compute Worked Days")
            {
                ApplicationArea = Basic;
                Caption = 'Compute Worked Days';
                Image = CalculateSalesTax;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Update the list with 13thSlip employees?',true)=true then begin
                      HRMEmployeeD.Reset;
                      HRMEmployeeD.SetFilter(HRMEmployeeD."Employee Category",'%1|%2','13thSlip','13thSlipS');
                      if HRMEmployeeD.Find('-') then begin
                        repeat
                          begin
                            PRLEmployeeDaysWorked.Reset;
                            PRLEmployeeDaysWorked.SetRange(PRLEmployeeDaysWorked."Employee Code",HRMEmployeeD."No.");
                            if not PRLEmployeeDaysWorked.Find('-') then begin
                              PRLPayrollPeriods.Reset;
                              PRLPayrollPeriods.SetFilter(PRLPayrollPeriods.Closed,'=%1',false);
                    //          PRLPayrollPeriods.SETFILTER("Payroll Code",'%1|%2','13thSlip','13thSlipS');
                              if PRLPayrollPeriods.Find('-') then begin
                              PRLEmployeeDaysWorked.Init;
                              PRLEmployeeDaysWorked."Employee Code":=HRMEmployeeD."No.";
                              PRLEmployeeDaysWorked."F.  Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                              PRLEmployeeDaysWorked."Payroll Period":=PRLPayrollPeriods."Date Openned";
                              PRLEmployeeDaysWorked."Period Month":=PRLPayrollPeriods."Period Month";
                              PRLEmployeeDaysWorked."Period Year":=PRLPayrollPeriods."Period Year";
                              PRLEmployeeDaysWorked."Current Instalment":=PRLPayrollPeriods."Current Instalment";
                              PRLEmployeeDaysWorked.Insert;
                              PRLEmployeeDaysWorked.Validate("Days Worked");
                              end;
                              end;
                          end;
                          until HRMEmployeeD.Next =0;
                        end;
                      end;
                    PRLEmployeeDaysWorked.Reset;
                    if PRLEmployeeDaysWorked.Find('-') then begin
                      repeat
                        begin
                        PRLEmployeeDaysWorked.Validate("Days Worked");
                        PRLEmployeeDaysWorked.Modify;
                        end;
                        until PRLEmployeeDaysWorked.Next=0;
                      end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PRLPayrollPeriods.Reset;
        PRLPayrollPeriods.SetRange(Closed,false);
        if PRLPayrollPeriods.Find('-') then begin
          SetFilter("Current Instalment",Format(PRLPayrollPeriods."Current Instalment"));
          SetFilter("Payroll Period",Format(PRLPayrollPeriods."Date Openned"));
          end;
    end;

    var
        PRLEmployeeDaysWorked: Record UnknownRecord99200;
        HRMEmployeeD: Record UnknownRecord61188;
        PRLPayrollPeriods: Record UnknownRecord99250;
}

