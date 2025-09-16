#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77367 "Admission Approval Entries Vie"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77391;

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
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field("Document Code";"Document Code")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Sequence";"Approval Sequence")
                {
                    ApplicationArea = Basic;
                }
                field(Approver_Id;Approver_Id)
                {
                    ApplicationArea = Basic;
                }
                field("Funding Category";"Funding Category")
                {
                    ApplicationArea = Basic;
                }
                field("Funding %";"Funding %")
                {
                    ApplicationArea = Basic;
                }
                field(Billable_Amount;Billable_Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Status";"Approval Status")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Comments";"Approval Comments")
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
            action(ViewDoc)
            {
                ApplicationArea = Basic;
                Caption = 'View Document';
                Image = Approval;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                      Clear(ACANewStudDocuments);
                      ACANewStudDocuments.Reset;
                      ACANewStudDocuments.SetRange("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SetRange("Index Number",Rec.Index);
                      ACANewStudDocuments.SetRange("Document Code",Rec."Document Code");
                      if ACANewStudDocuments.Find('-') then begin
                        Page.Run(77562,ACANewStudDocuments);
                        end;
                     /* IF Rec."Document Code" = Rec."Document Code"::"2" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77563,ACANewStudDocuments);
                        END;
                      END;
                        IF Rec."Document Code" = Rec."Document Code"::"3" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77564,ACANewStudDocuments);
                        END;
                      END;
                          IF Rec."Document Code" = Rec."Document Code"::"4" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77565,ACANewStudDocuments);
                        END;
                      END;
                            IF Rec."Document Code" = Rec."Document Code"::"5" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77566,ACANewStudDocuments);
                        END;
                      END;
                              IF Rec."Document Code" = Rec."Document Code"::"6" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77567,ACANewStudDocuments);
                        END;
                      END;
                                IF Rec."Document Code" = Rec."Document Code"::"7" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77568,ACANewStudDocuments);
                        END;
                      END;
                                  IF Rec."Document Code" = Rec."Document Code"::"8" THEN BEGIN
                      CLEAR(ACANewStudDocuments);
                      ACANewStudDocuments.RESET;
                      ACANewStudDocuments.SETRANGE("Academic Year",Rec."Academic Year");
                      ACANewStudDocuments.SETRANGE("Index Number",Rec.Index);
                      ACANewStudDocuments.SETRANGE("Document Code",Rec."Document Code");
                      IF ACANewStudDocuments.FIND('-') THEN BEGIN
                        PAGE.RUN(77569,ACANewStudDocuments);
                        END;
                      END;
                      */

                end;
            }
        }
    }

    var
        ACANewStudDocuments: Record UnknownRecord77360;
}

