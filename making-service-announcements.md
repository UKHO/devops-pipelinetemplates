# Service Announcements

For version changes to the repository, make use of the Service Announcement channel and refer to this template for the message.

The `devops-pipelinetemplates` has been updated to version X.Y.Z.

{% if MAJOR %}

This major release introduces significant changes that may affect existing pipelines. Changes in this major update are:

- [Concise bullet point list of the changes involved in this update appending the breaking changes bullet points with `(breaking change)` along with justification]

Please review the release notes and documentation carefully to understand the new features and any breaking changes.

{% elif MINOR %}

This minor update includes new functionality and improvements while maintaining backward compatibility. Changes in this minor update are:

- [Concise bullet point list of the changes involved in this update]

These changes enhance usability and adds new capabilities to support more use cases.

{% elif PATCH %}

This patch addresses a specific issue where [brief description of the issue]. The problem was caused by [short cause], and it has now been resolved.

{% endif %}

You can find the template and more information here:
🔗 https://github.com/ukho/devops-pipelinetemplates
