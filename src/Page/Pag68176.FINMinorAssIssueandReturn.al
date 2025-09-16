#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68176 "FIN-Minor Ass Issue and Return"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61725;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Minor Asset No";"Minor Asset No")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Requisition No.";"Requisition No.")
                {
                    ApplicationArea = Basic;
                }
                field("Issued To";"Issued To")
                {
                    ApplicationArea = Basic;
                }
                field("Issued By";"Issued By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Issued";"Date Issued")
                {
                    ApplicationArea = Basic;
                }
                field("Date Returned";"Date Returned")
                {
                    ApplicationArea = Basic;
                }
                field("Received By";"Received By")
                {
                    ApplicationArea = Basic;
                }
                field("Inspection Done By";"Inspection Done By")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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
            group(Returns)
            {
                Caption = 'Returns';
                action(Return)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        MinorAss.Reset;
                        MinorAss.SetRange(MinorAss.Select,true);
                        MinorAss.SetRange(MinorAss.Returned,false);
                        if MinorAss.Find('-') then begin
                          repeat
                            MinorAss.Returned:=true;
                            MinorAss."Date Returned":=Today;
                            MinorAss."Received By":=UserId;
                            MinorAss.Modify;
                            //Fixed Asset
                            if FixedAsset.Get("Minor Asset No") then begin
                        //      FixedAsset."Issued Out":=FALSE;
                              FixedAsset.Modify;
                            end;
                          until MinorAss.Next=0;
                        end;
                    end;
                }
                separator(Action1102756028)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetRange(Returned,false);
    end;

    var
        MinorAss: Record UnknownRecord61725;
        FixedAsset: Record "Fixed Asset";
}

