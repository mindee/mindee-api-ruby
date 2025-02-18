---
title: Ruby Image Compression
category: 622b805aaec68102ea7fcbc2
slug: ruby-image-compression
parentDoc: 6294d97ee723f1008d2ab28e
---

Some images might be a bit too large.
Instead of having third-party libraries reduce them or having to check them manually,
you can use the Mindee Ruby Client library's image compression feature:

```ruby
    # Load a local input source.
    input_file_path = "path/to/your/file.ext"
    output_file_path = "path/to/the/compressed/file.ext"
    file_input = Mindee::Input::Source::PathInputSource.new(input_file_path)

    # An experimental PDF compression feature is also available, this check ensures we only apply it to images.
    unless file_input.pdf?
    
        # We advise you test the quality value yourself, as results may vary greatly depending on the input file
        file_input.compress!(quality: 50)
    
        # Write the output file locally for visual checking:
        File.write(output_file_path, file_input.io_stream.read)
    end
```

