#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50215 "Import/export Band Entries"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Funding Band Entries";"Funding Band Entries")
            {
                XmlName = 'Band';
                fieldelement(EntryNo;"Funding Band Entries"."Entry no.")
                {
                }
                fieldelement(StudentNo;"Funding Band Entries"."Student No.")
                {
                }
                fieldelement(StudentName;"Funding Band Entries"."Student Name")
                {
                }
                fieldelement(Surname;"Funding Band Entries".Surname)
                {
                }
                fieldelement(KCSEIndexNo;"Funding Band Entries"."KCSE Index No.")
                {
                }
                fieldelement(PrgorammeName;"Funding Band Entries"."Programm Description")
                {
                }
                fieldelement(Cost;"Funding Band Entries"."Programme Cost")
                {
                }
                fieldelement(BandCode;"Funding Band Entries"."Band Code")
                {
                }
                fieldelement(householdpercentage;"Funding Band Entries"."HouseHold Percentage")
                {
                }
                fieldelement(HouseholdSem1;"Funding Band Entries"."SEM1 Fee")
                {
                }
                fieldelement(Householdsem2;"Funding Band Entries"."SEM2 Fee")
                {
                }

                trigger OnAfterInitRecord()
                begin
                       if CaptionRow then begin
                                            CaptionRow := false;
                                            currXMLport.Skip();
                                        end;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "Funding Band Entries"."Academic Year":=Acadyear;
                    "Funding Band Entries"."Batch No.":=batchcode;
                    "Funding Band Entries".Semester:=Semester;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        CaptionRow:=true;
    end;

    var
        batchcode: Code[20];
        Acadyear: Code[20];
        CaptionRow: Boolean;
        Semester: Code[25];


    procedure getheader(var BatcHeader: Record "Fund Band Batch")
    begin
        batchcode:=BatcHeader."Document No.";
        Acadyear:=BatcHeader."Academic Year";
        Semester:=BatcHeader.Semester;
    end;
}

