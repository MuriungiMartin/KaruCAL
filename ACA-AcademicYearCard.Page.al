#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68509 "ACA-Academic Year Card"
{
    PageType = Card;
    SourceTable = UnknownTable61382;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrentOnPush;
                    end;
                }
                field("Graduating Group";"Graduating Group")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Date";"Graduation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Allow View of Transcripts";"Allow View of Transcripts")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (PhD)";"Graduation Group (PhD)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Masters)";"Graduation Group (Masters)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Degree)";"Graduation Group (Degree)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Diploma)";"Graduation Group (Diploma)")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group (Certificate)";"Graduation Group (Certificate)")
                {
                    ApplicationArea = Basic;
                }
                field("ID Card Validity";"ID Card Validity")
                {
                    ApplicationArea = Basic;
                }
                field("Allow CATs Exempt";"Allow CATs Exempt")
                {
                    ApplicationArea = Basic;
                }
                field("Release Results";"Release Results")
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
            action(Application_deadlines)
            {
                ApplicationArea = Basic;
                Image = Info;
                Promoted = true;
                RunObject = Page "ACA-Online Application Notes";
                RunPageLink = "Academic Year"=field(Code);
            }
            action("Academic Year Schedule")
            {
                ApplicationArea = Basic;
                Image = CalendarMachine;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Academic Year Schedule";
                RunPageLink = "Academic Year"=field(Code);
            }
        }
    }

    var
        AcademicY: Record UnknownRecord61382;

    local procedure CurrentOnPush()
    begin
          if Current=true then begin
          if Confirm('Are you sure you want to make '+Code+' as the current academic year?') then begin
          AcademicY.Reset;
          if AcademicY.Find('-') then begin
          repeat
          if AcademicY.Code<>Code then begin
          AcademicY.Current:=false;
          AcademicY.Modify;
          end;
          until AcademicY.Next=0;
          end;
          end;
          end;
    end;
}

