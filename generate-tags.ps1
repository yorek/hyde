$posts = Get-ChildItem .\_posts\*.md -Recurse

$tags = @()

foreach($post in $posts)
{
    $postTags = Get-Content $post.FullName | Where-Object {$_ -like "tags:*"}
    if (-not $postTags) { continue }
    $postTags = $postTags.Remove(0, 5).Trim()       
    if (-not $postTags) { continue }

    foreach($pt in $postTags.Split(' '))
    {
        if (-Not $tags.Contains($pt))
        {
            $tags +=$pt 
        }
    }
}

Remove-Item .\tag\ -Force -Recurse -ErrorAction SilentlyContinue
New-Item .\tag -ItemType "directory" > $null

$template = "---
layout: tag
title: Post tagged with {0}
tag: {0}
---
"

foreach($tag in $tags)
{
    $template -f $tag | Out-File (".\tag\{0}.html" -f $tag) -Encoding "Default" 
}

