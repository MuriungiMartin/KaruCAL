#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5145 "Contact Through"
{
    Caption = 'Contact Through';
    DataCaptionFields = "Contact No.",Name;
    Editable = false;
    PageType = List;
    SourceTable = "Communication Method";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the contact to which the phone number is related. There are two options:';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the phone number or e-mail address.';
                }
                field(Number;Number)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the telephone number.';
                    Visible = NumberVisible;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the contact''s email address.';
                    Visible = EmailVisible;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        EmailVisible := true;
        NumberVisible := true;
    end;

    trigger OnOpenPage()
    begin
        SetFilter(Number,'<>''''');
        if Find('-') then begin
          CurrPage.Caption := Text000;
          NumberVisible := true;
          EmailVisible := false;
        end else begin
          Reset;
          SetFilter("E-Mail",'<>''''');
          if Find('-') then begin
            CurrPage.Caption := Text001;
            NumberVisible := false;
            EmailVisible := true;
          end else
            CurrPage.Close;
        end;
    end;

    var
        Text000: label 'Contact Phone Numbers';
        Text001: label 'Contact Emails';
        [InDataSet]
        NumberVisible: Boolean;
        [InDataSet]
        EmailVisible: Boolean;
}

