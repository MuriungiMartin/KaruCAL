#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9170 "Profile Import/Export"
{
    Caption = 'Profile Import/Export';
    FormatEvaluate = Xml;

    schema
    {
        textelement(Profiles)
        {
            tableelement(Profile;Profile)
            {
                XmlName = 'Profile';
                fieldattribute(ID;Profile."Profile ID")
                {
                }
                fieldattribute(Description;Profile.Description)
                {
                }
                fieldattribute(RoleCenterID;Profile."Role Center ID")
                {
                }
                fieldattribute(DefaultRoleCenter;Profile."Default Role Center")
                {

                    trigger OnAfterAssignField()
                    var
                        Profile2: Record "Profile";
                    begin
                        if Profile."Default Role Center" then begin
                          Profile2.SetRange("Default Role Center",true);
                          if not Profile2.IsEmpty then
                            Profile."Default Role Center" := false;
                        end;
                    end;
                }
                tableelement("Profile Metadata";"Profile Metadata")
                {
                    LinkFields = "Profile ID"=field("Profile ID");
                    LinkTable = "Profile";
                    MinOccurs = Zero;
                    XmlName = 'ProfileMetadata';
                    fieldattribute(ProfileID;"Profile Metadata"."Profile ID")
                    {
                    }
                    fieldattribute(PageID;"Profile Metadata"."Page ID")
                    {
                    }
                    fieldattribute(PersonalizationID;"Profile Metadata"."Personalization ID")
                    {
                    }
                    textelement(PageMetadata)
                    {
                        TextType = BigText;

                        trigger OnBeforePassVariable()
                        var
                            MetadataInStream: InStream;
                            XDoc: dotnet XDocument;
                        begin
                            Clear(PageMetadata);
                            "Profile Metadata".CalcFields("Page Metadata Delta");

                            if "Profile Metadata"."Page Metadata Delta".Hasvalue then begin
                              "Profile Metadata"."Page Metadata Delta".CreateInstream(MetadataInStream,Textencoding::UTF8);
                              XDoc := XDoc.Load(MetadataInStream);
                              PageMetadata.AddText(XmlDeltaHeaderTxt + XDoc.ToString);
                            end;
                        end;

                        trigger OnAfterAssignVariable()
                        var
                            MetadataOutStream: OutStream;
                        begin
                            if PageMetadata.Length > 0 then begin
                              "Profile Metadata"."Page Metadata Delta".CreateOutstream(MetadataOutStream,Textencoding::UTF8);
                              PageMetadata.Write(MetadataOutStream);
                            end;
                        end;
                    }
                }
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

    var
        XmlDeltaHeaderTxt: label '<?xml version="1.0"?>', Locked=true;
}

