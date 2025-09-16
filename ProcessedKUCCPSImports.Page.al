#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70082 "Processed KUCCPS Imports"
{
    PageType = List;
    SourceTable = UnknownTable70082;
    SourceTableView = where(Processed=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ser;ser)
                {
                    ApplicationArea = Basic;
                }
                field(Index;Index)
                {
                    ApplicationArea = Basic;
                }
                field(Admin;Admin)
                {
                    ApplicationArea = Basic;
                }
                field(Prog;Prog)
                {
                    ApplicationArea = Basic;
                }
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field("Alt. Phone";"Alt. Phone")
                {
                    ApplicationArea = Basic;
                }
                field(Box;Box)
                {
                    ApplicationArea = Basic;
                }
                field(Codes;Codes)
                {
                    ApplicationArea = Basic;
                }
                field(Town;Town)
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Slt Mail";"Slt Mail")
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Process Admissions")
                {
                    ApplicationArea = Basic;
                    Caption = '&Process Admissions';
                    Image = ExecuteBatch;
                    Promoted = true;

                    trigger OnAction()
                    var
                        ACAAdmImportedJABBuffer: Record UnknownRecord70082;
                    begin
                        if Confirm('Process All Students?',false)=true then  begin
                        Report.Run(51348,true,true);
                          end else begin
                            ACAAdmImportedJABBuffer.Reset;
                            ACAAdmImportedJABBuffer.SetRange(ser,Rec.ser);
                            if ACAAdmImportedJABBuffer.Find('-') then begin
                              Report.Run(51348,false,false,ACAAdmImportedJABBuffer);
                              end;
                            end;
                            CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        JAB: Record UnknownRecord70082;
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

