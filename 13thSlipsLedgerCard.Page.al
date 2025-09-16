#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99077 "13thSlips  Ledger Card"
{
    PageType = Card;
    SourceTable = UnknownTable99210;

    layout
    {
        area(content)
        {
            group("Visitor Ledger Edit")
            {
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
                    // // IF "L. Name"<>0T THEN ERROR('Already Checked in!');
                    // //  users1.RESET;
                    // //  users1.SETRANGE("User Name",USERID);
                    // //  IF users1.FIND('-') THEN BEGIN  END;
                    // // TESTFIELD(Rec."Period Month");
                    // // TESTFIELD("F.  Name");
                    // // IF CONFIRM('Register '+Rec."Payroll Period", TRUE)=FALSE THEN ERROR('Registration Cancelled by '+USERID);
                    // // Rec."M. Name":=TODAY;
                    // // Rec."L. Name":=TIME;
                    // // IF users1."Full Name"='' THEN
                    // // Rec."Daily Rate":=USERID
                    // // ELSE Rec."Daily Rate":=users1."Full Name";
                    // // Rec.MODIFY;
                    // // readMessage:='Clocked in Successfully!';
                    // //  MESSAGE(readMessage);
                end;
            }
            action("Check Out")
            {
                ApplicationArea = Basic;
                Image = Close;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // //
                    // // IF "L. Name"=0T THEN ERROR('Not Checked in!');
                    // // //TESTFIELD(Comment);
                    // // IF "Checked Out"=TRUE THEN ERROR('Already Checked out!');
                    // //
                    // // // // ItemstoCheckOut.RESET;
                    // // // // ItemstoCheckOut.SETRANGE(ItemstoCheckOut."Staff Code","Visit No.");
                    // // // // ItemstoCheckOut.SETRANGE(ItemstoCheckOut."Staff ID","Staff No.");
                    // // // // ItemstoCheckOut.SETRANGE(ItemstoCheckOut.Cleared,FALSE);
                    // // // // ItemstoCheckOut.SETFILTER(ItemstoCheckOut."Item Description",'<>%1','');
                    // // // // IF ItemstoCheckOut.FIND('-') THEN BEGIN
                    // // // //    ERROR('Please Check out all Peronal Items First');
                    // // // //  END;
                    // //
                    // // users1.RESET;
                    // //  users1.SETRANGE("User Name",USERID);
                    // //  IF users1.FIND('-') THEN BEGIN  END;
                    // // IF CONFIRM('Check-out '+Rec."Payroll Period"+'?', TRUE)=FALSE THEN ERROR('Check-out Cancelled by '+USERID);
                    // // Rec."Time Out":=TIME;
                    // // Rec."Checked Out":=TRUE;
                    // // IF users1."Full Name"='' THEN
                    // // Rec."Signed Out By":=USERID
                    // // ELSE Rec."Signed Out By":=users1."Full Name";
                    // // Rec.MODIFY;
                    // // CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //IF (("Checked Out"=TRUE) OR ("Daily Rate"<>'')) THEN editableBool:=FALSE ELSE editableBool:=TRUE;
    end;

    trigger OnInit()
    begin
        editableBool:=true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Comment:='Checked in';
        "Comment By":=UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Comment:='Checked in';
        "Comment By":=UserId;
    end;

    var
        users1: Record User;
        editableBool: Boolean;
        StaffCard: Record UnknownRecord61188;
}

