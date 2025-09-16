#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 181 "Additional Customer Terms"
{
    Caption = 'Additional Customer Terms';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "License Agreement";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PleaseReadLbl;PleaseReadLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        ShowEULA
                    end;
                }
                label(Control3)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = ConfirmationForAcceptingLicenseTermsQst;
                }
                field(Accepted;Accepted)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the license agreement was accepted.';
                }
                field("Accepted By";"Accepted By")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the person that accepted the license agreement.';
                }
                field("Accepted On";"Accepted On")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date the license agreement is accepted.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Read the Additional Customer Terms")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Read the Additional Customer Terms';
                Image = Agreement;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Read the additional customer terms.';

                trigger OnAction()
                begin
                    ShowEULA;
                end;
            }
            action("&Accept the Additional Customer Terms")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Accept the Additional Customer Terms';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Accept the additional customer terms.';

                trigger OnAction()
                begin
                    Validate(Accepted,true);
                    CurrPage.Update;
                end;
            }
        }
    }

    var
        ConfirmationForAcceptingLicenseTermsQst: label 'Do you accept the Partner Agreement?';
        PleaseReadLbl: label 'Please read and accept the additional customer terms.';
}

