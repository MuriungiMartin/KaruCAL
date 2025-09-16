#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70075 "Proc-Preq. Categories/Year"
{
    CardPageID = "Proc-Preq. Categories/yr Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable60225;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Preq. Year";"Preq. Year")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field("Preq. Category";"Preq. Category")
                {
                    ApplicationArea = Basic;
                }
                field("Prequalified Suppliers";"Prequalified Suppliers")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup1000000007)
            {
                action("Prequalification Report")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        preqYC.Reset;
                        preqYC.SetRange("Preq. Year", Rec."Preq. Year");
                        preqYC.SetRange("Preq. Category", Rec."Preq. Category");
                        Report.Run(Report::"Proc-Prequalification Summary",true,false,preqYC);
                    end;
                }
            }
        }
    }

    var
        preqYC: Record UnknownRecord60225;
}

