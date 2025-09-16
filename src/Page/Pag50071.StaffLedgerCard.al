#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50071 "Staff Ledger Card"
{
    PageType = Card;
    SourceTable = "ACA-Exam Supp. Units";

    layout
    {
        area(content)
        {
            group("Visitor Ledger Edit")
            {
                field("Visit No.";"Visit No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                    Enabled = true;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                }
                field("Full Name";"Full Name")
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Office Station/Department";"Office Station/Department")
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time In";"Time In")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Signed in by";"Signed in by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Out";"Time Out")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Signed Out By";"Signed Out By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    Editable = editableBool;
                }
                field("Comment By";"Comment By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Checked Out";"Checked Out")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Det)
            {
                Caption = 'Personal Items Recording';
                part(Control1000000021;"Student Deferment/Withdrawal")
                {
                    SubPageLink = "Staff Code"=field("Staff No."),
                                  "Staff ID"=field("Visit No.");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Check In")
            {
                ApplicationArea = Basic;
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    readMessage: Text[100];
                begin
                    Clear(readMessage);
                    if "Time In"<>0T then Error('Already Checked in!');
                      users1.Reset;
                      users1.SetRange("User Name",UserId);
                      if users1.Find('-') then begin  end;
                    TestField(Rec.Company);
                    TestField("Staff No.");
                    TestField(Rec."Phone No.");
                    TestField(Rec."Full Name");
                    if Confirm('Register '+Rec."Full Name", true)=false then Error('Registration Cancelled by '+UserId);
                    Rec."Transaction Date":=Today;
                    Rec."Time In":=Time;
                    if users1."Full Name"='' then
                    Rec."Signed in by":=UserId
                    else Rec."Signed in by":=users1."Full Name";
                    Rec.Modify;
                    readMessage:='Clocked in Successfully!';
                      Message(readMessage);
                end;
            }
            action("Check Out")
            {
                ApplicationArea = Basic;
                Image = Close;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemstoCheckOut: Record "ACA-SuppExam Fail Reasons";
                begin

                    if "Time In"=0T then Error('Not Checked in!');
                    TestField(Comment);
                    if "Checked Out"=true then Error('Already Checked out!');

                    ItemstoCheckOut.Reset;
                    ItemstoCheckOut.SetRange(ItemstoCheckOut."Staff Code","Visit No.");
                    ItemstoCheckOut.SetRange(ItemstoCheckOut."Staff ID","Staff No.");
                    ItemstoCheckOut.SetRange(ItemstoCheckOut.Cleared,false);
                    ItemstoCheckOut.SetFilter(ItemstoCheckOut."Item Description",'<>%1','');
                    if ItemstoCheckOut.Find('-') then begin
                        Error('Please Check out all Peronal Items First');
                      end;

                    users1.Reset;
                      users1.SetRange("User Name",UserId);
                      if users1.Find('-') then begin  end;
                    if Confirm('Check-out '+Rec."Full Name"+'?', true)=false then Error('Check-out Cancelled by '+UserId);
                    Rec."Time Out":=Time;
                    Rec."Checked Out":=true;
                    if users1."Full Name"='' then
                    Rec."Signed Out By":=UserId
                    else Rec."Signed Out By":=users1."Full Name";
                    Rec.Modify;
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if (("Checked Out"=true) or ("Signed in by"<>'')) then editableBool:=false else editableBool:=true;
    end;

    trigger OnInit()
    begin
        editableBool:=true;
    end;

    var
        users1: Record User;
        editableBool: Boolean;
        StaffCard: Record UnknownRecord61188;
}

