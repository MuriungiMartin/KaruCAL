#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65212 "Lect  Load Details"
{
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = UnknownTable65202;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours";"No. Of Hours")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours Contracted";"No. Of Hours Contracted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                    Editable = editableStatus;
                }
                field(Approved;Approved)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        /*editableStatus:=TRUE;
        Rec.CALCFIELDS("Exams Submitted");
        //Rec.CALCFIELDS(Reject);
        IF (("Exams Submitted") ) THEN editableStatus:=FALSE;*/

    end;

    var
        editableStatus: Boolean;
}

