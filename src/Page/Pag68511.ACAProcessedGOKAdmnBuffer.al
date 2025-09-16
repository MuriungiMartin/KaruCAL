#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68511 "ACA-Processed GOK Admn Buffer"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61369;
    SourceTableView = where(Field16=const(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                }
                field("S.No";"S.No")
                {
                    ApplicationArea = Basic;
                }
                field("Degree Code";"Degree Code")
                {
                    ApplicationArea = Basic;
                }
                field("K.C.S.E Index Number";"K.C.S.E Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("Candidates Name";"Candidates Name")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Home County";"Home County")
                {
                    ApplicationArea = Basic;
                }
                field("Residence District";"Residence District")
                {
                    ApplicationArea = Basic;
                }
                field("P.O Box";"P.O Box")
                {
                    ApplicationArea = Basic;
                }
                field("Address Code";"Address Code")
                {
                    ApplicationArea = Basic;
                }
                field(Town;Town)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Print Admission Letter")
            {
                ApplicationArea = Basic;
                Caption = '&Print Admission Letter';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Admissions.Reset;
                    Admissions.SetRange(Admissions."Admission No.","Admission No.");
                    if Admissions.Find('-') then
                      begin
                        Report.Run(51339,true,true,Admissions);
                      end;
                end;
            }
        }
    }

    var
        JAB: Record UnknownRecord61369;
        Admissions: Record UnknownRecord61372;
        AdminSetup: Record UnknownRecord61371;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AdminCode: Code[20];


    procedure SplitNames(var Names: Text[100];var Surname: Text[50];var "Other Names": Text[50])
    var
        lngPos: Integer;
    begin
        /*Get the position of the space character*/
        lngPos:=StrPos(Names,' ');
        if lngPos<>0 then
          begin
            Surname:=CopyStr(Names, 1 , lngPos-1);
            "Other Names":=CopyStr(Names,lngPos +1);
          end;

    end;
}

