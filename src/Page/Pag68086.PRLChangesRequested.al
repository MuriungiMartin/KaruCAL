#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68086 "PRL-Changes Requested"
{
    PageType = List;
    SourceTable = UnknownTable61123;
    SourceTableView = where(Closed=const(No));

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Basic Pay";"Basic Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Effective Date";"Effective Date")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field("New Amount";"New Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Hrs Worked";"Hrs Worked")
                {
                    ApplicationArea = Basic;
                }
                field("Overtime Type";"Overtime Type")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Approved By";"Approved By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin
                          SetRange(Status,Status::Approved);
                          SetRange(Closed,false);
                          if Find('-') then begin
                          repeat
                              Closed:=true;
                              "Date Closed":=Today;
                              "Approved By":=UserId;
                              Modify;
                          until Next=0;
                          end;
                    end;
                }
                separator(Action1102756031)
                {
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = Print;

                    trigger OnAction()
                    begin
                        Reset;
                        Report.Run(39005528);
                        Reset;
                    end;
                }
            }
        }
    }
}

