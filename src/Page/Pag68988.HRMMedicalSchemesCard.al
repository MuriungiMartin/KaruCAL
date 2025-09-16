#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68988 "HRM-Medical Schemes Card"
{
    PageType = Card;
    SourceTable = "HRM-Medical Schemes";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Scheme No";"Scheme No")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Insurer";"Medical Insurer")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Name";"Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Type";"Scheme Type")
                {
                    ApplicationArea = Basic;
                }
                field(Currency;Currency)
                {
                    ApplicationArea = Basic;
                }
                field("In-patient limit";"In-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Out-patient limit";"Out-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Area Covered";"Area Covered")
                {
                    ApplicationArea = Basic;
                }
                field("Dependants Included";"Dependants Included")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum No of Dependants";"Maximum No of Dependants")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Members";"Scheme Members")
                {
                    ApplicationArea = Basic;
                }
                field(Period;Period)
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102755015;"HRM-Med. Scheme Members List")
            {
                SubPageLink = "Scheme No"=field("Scheme No");
            }
        }
        area(factboxes)
        {
            part(Control1102755011;"HRM-Med. Schemes FactBox")
            {
                SubPageLink = "Scheme No"=field("Scheme No");
            }
            systempart(Control1102755010;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Scheme Status")
            {
                Caption = 'Scheme Status';
                action("Renew Scheme")
                {
                    ApplicationArea = Basic;
                    Caption = 'Renew Scheme';
                    Image = ReOpen;

                    trigger OnAction()
                    begin
                          if Confirm('Are you sure you want to renew this scheme for the next Period?')  then begin
                           Status:=Status::Renewed;
                           Modify;
                           Message('Scheme Number %1 has been renewed',"Scheme No");
                          end;
                    end;
                }
                action("Close Scheme")
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Scheme';
                    Image = Close;

                    trigger OnAction()
                    begin
                          if Confirm(' Once a scheme is closed no claims can be made on it.Are you sure you want to Close this Scheme?')  then begin
                          Status:=Status::Closed;
                           Modify;
                           Message('Scheme Number %1 has been Closed',"Scheme No");
                          end;
                    end;
                }
            }
        }
    }
}

