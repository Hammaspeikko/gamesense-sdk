(define custom-colors (list green-color green-color orange-color orange-color red-color red-color))

(define (percent value keys)
  (let* ((number-of-keys (length keys))
    (percent-per-key (/ 255.0 number-of-keys))
    (num-keys-lit (cond ((== value 0) 0)
                        ((<= value percent-per-key) 1)
                        (else (min (list number-of-keys
                             (integer (* (/ (+ percent-per-key value) 255.0)
                                         number-of-keys)))))))
    (remainder (- value (* percent-per-key (max (list (- num-keys-lit 1) 0)))))
    (remainder-scale (/ (* 255 remainder) percent-per-key))
    (scaled-final-key-color (map (lambda (color-bit)
                              (integer (/ (* remainder-scale color-bit) 255)))   (nth custom-colors num-keys-lit)))
    (key-colors (map (lambda (key-index)
                       (cond ((nil? (nth keys key-index)) '())
                          ((< key-index num-keys-lit) (nth custom-colors key-index))
                          ((== key-index num-keys-lit) scaled-final-key-color)
                          (else black-color)))
                     (interval 1 number-of-keys))))
    key-colors))

(define visualizer-columns '(
  (0xED 0xEC 0xEB 0xEA 0xE9 0xE8)
  (0xE0 0xE1 0x39 0x2B 0x35 0x29)
  (0xE3 ()   0x04 0x14 0x1E ()  )
  (()   0x1D 0x16 0x1A 0x1F 0x3A)
  (0xE2 0x1B 0x07 0x08 0x20 0x3B)
  (()   0x06 0x09 0x15 0x21 0x3C)
  (()   0x19 0x0A 0x17 0x22 0x3D)
  (()   0x05 0x0B 0x1C 0x23 ()  )
  (()   0x11 0x0D 0x18 0x24 0x3E)
  (()   0x10 0x0E 0x0C 0x25 0x3F)
  (()   0x36 0x0F 0x12 0x26 0x40)
  (0xE6 0x37 0x33 0x13 0x27 0x41)
  (0xEF 0x38 0x34 0x2F 0x2D 0x42)
  (0x65 0xE5 ()   0x30 0x2E 0x43)
  (()   ()   ()   ()   ()   0x44)
  (0xE4 ()   0x28 0x31 0x2A 0x45)
  (0x50 ()   ()   0x4C 0x49 0x46)
  (0x51 0x52 ()   0x4D 0x4A 0x47)
  (0x4F ()   ()   0x4E 0x4B 0x48)
  (0x62 0x59 0x5C 0x5F 0x53 ()  )
  (()   0x5A 0x5D 0x60 0x54 ()  )
  (0x63 0x5B 0x5E 0x61 0x55 ()  )
  (()   0x58 ()   0x57 0x56 0x00)
))

(handler "AUDIO"
  (lambda (data)
    (let* ((vals (values: data))
          (colors (map percent vals visualizer-columns))
          (filtered-zones (filter notnil? (reduce append '() visualizer-columns)))
          (filtered-colors (filter notnil? (reduce append '() colors))))
      (on-device "rgb-per-key-zones" show-on-keys: filtered-zones filtered-colors))))

(add-event-per-key-zone-use "AUDIO" "all")
