#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68016 "HRM-Password Generation"
{
    PageType = Card;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Fulname;"full Names")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                }
                field(Password;Password)
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
            action(Singlepass)
            {
                ApplicationArea = Basic;
                Caption = 'Reset Current Password';

                trigger OnAction()
                begin
                    if Confirm('This will reset the Password for the Current Employee, Continue?',false)=false then exit;

                    Password:="ID Number";
                    Modify;
                    CurrPage.Update;
                    Message('Passwords for '''+"full Names"+''' has been successfully reset.');
                end;
            }
            action(DoublePass)
            {
                ApplicationArea = Basic;
                Caption = 'Reset All Passwords';

                trigger OnAction()
                begin
                    if Confirm('This will reset all the Employees Passswords, Continue?',false)=false then exit;
                    Employ.Reset;
                    if Employ.Find('-') then begin
                    repeat
                    begin

                    Employ.Password:=Employ."ID Number";
                    Employ.Modify;

                    end;
                    until Employ.Next=0;
                    end;

                    CurrPage.Update;
                    Message('Passwords for all Employees have been successfully reset.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
         "full Names":="First Name"+' '+"Middle Name"+' '+"Last Name";
    end;

    var
        Employ: Record UnknownRecord61188;
        "full Names": Code[70];
}

