#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68408 "HRM-Vacant Positions"
{
    Editable = false;
    PageType = Card;
    SourceTable = UnknownTable61056;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("No of Posts";"No of Posts")
                {
                    ApplicationArea = Basic;
                }
                field("Occupied Position";"Occupied Position")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

          Reset;
         if Find('-') then begin
          repeat
          CalcFields("Occupied Position");
          // MESSAGE('%1',"Occupied Position");
            "Vacant Posistions":="No of Posts"-"Occupied Position";
          Modify;
         until Next=0;
         end;
          Reset;
          SetCurrentkey("Vacant Posistions");
          SetFilter("Vacant Posistions",'>%1',0);
    end;
}

