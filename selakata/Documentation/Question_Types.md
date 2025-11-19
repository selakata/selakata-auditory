# Question Types

## Overview
Quiz mendukung berbagai tipe soal berdasarkan field `type` di Question entity.

## Supported Types

### Type 1: Multiple Choice
**Description:** User memilih jawaban dari beberapa pilihan

**UI Component:** `AnswerView`

**Backend Format:**
```json
{
  "type": 1,
  "text": "Pilih kata yang didengar",
  "answerList": [
    {
      "text": "Dara",
      "isCorrect": false
    },
    {
      "text": "Dasi",
      "isCorrect": true
    }
  ]
}
```

**Features:**
- List atau grid layout
- Visual feedback (green/red)
- Tap to select
- Auto-submit on selection

**Screenshot:**
```
┌─────────────────────────┐
│ Pilih kata yang didengar│
├─────────────────────────┤
│  ○ Dara                 │
│  ○ Dasi                 │
│  ○ Dari                 │
│  ○ Dadu                 │
└─────────────────────────┘
```

### Type 2: Fill in the Blank
**Description:** User mengetik jawaban di text field

**UI Component:** `FillInBlankView`

**Backend Format:**
```json
{
  "type": 2,
  "text": "Ketik kata yang kamu dengar",
  "answerList": [
    {
      "text": "Dasi",
      "isCorrect": true
    }
  ]
}
```

**Features:**
- Text field input
- Case-insensitive comparison
- Trim whitespace
- Show correct answer on wrong
- Submit button
- Visual feedback

**Screenshot:**
```
┌─────────────────────────┐
│ Ketik kata yang kamu    │
│ dengar                  │
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ Ketik jawaban...    │ │
│ └─────────────────────┘ │
│                         │
│ [Submit]                │
└─────────────────────────┘
```

## Implementation

### QuizView Logic
```swift
if viewModel.currentQuestion.type == 2 {
    // Fill in the blank
    FillInBlankView(...)
} else {
    // Multiple choice (default)
    AnswerView(...)
}
```

### Answer Validation

#### Type 1: Multiple Choice
```swift
func selectAnswer(_ answer: Answer) {
    if answer.isCorrect {
        correctAnswer += 1
    }
}
```

#### Type 2: Fill in the Blank
```swift
func submitTextAnswer() {
    let correctAnswerText = currentQuestion.answerList.first(where: { $0.isCorrect })?.text ?? ""
    let isCorrect = userTextAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == 
                   correctAnswerText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    if isCorrect {
        correctAnswer += 1
    }
}
```

## User Flow

### Type 1: Multiple Choice
```
1. Audio selesai
2. Pilihan muncul
3. User tap salah satu pilihan
4. Langsung submit & show feedback
5. Next button muncul
```

### Type 2: Fill in the Blank
```
1. Audio selesai
2. Text field muncul & auto-focus
3. User ketik jawaban
4. Submit button muncul (jika ada input)
5. User tap submit
6. Show feedback (benar/salah + correct answer)
7. Next button muncul
```

## Answer Comparison (Type 2)

### Case-Insensitive
```swift
"Dasi" == "dasi" == "DASI"  // All correct
```

### Whitespace Trimming
```swift
"  Dasi  " == "Dasi"  // Correct
```

### Exact Match Required
```swift
"Dasi" != "Dasi nya"  // Wrong
"Dasi" != "Das"       // Wrong
```

## Backend Guidelines

### Type 1: Multiple Choice
- Provide 2-6 answer options
- Only one `isCorrect: true`
- All answers should be plausible
- Order by `urutan` field

### Type 2: Fill in the Blank
- Provide only 1 answer (the correct one)
- Keep answer short (1-3 words)
- Use simple, unambiguous words
- Consider common typos/variations

## Future Types (Planned)

### Type 3: Multiple Choice with Images
```json
{
  "type": 3,
  "answerList": [
    {
      "text": "Cat",
      "imageURL": "https://...",
      "isCorrect": true
    }
  ]
}
```

### Type 4: Ordering/Sequencing
```json
{
  "type": 4,
  "text": "Urutkan kata-kata ini",
  "answerList": [
    {"text": "Saya", "order": 1},
    {"text": "makan", "order": 2},
    {"text": "nasi", "order": 3}
  ]
}
```

### Type 5: True/False
```json
{
  "type": 5,
  "text": "Audio ini mengucapkan 'Dasi'",
  "answerList": [
    {"text": "Benar", "isCorrect": true},
    {"text": "Salah", "isCorrect": false}
  ]
}
```

## Testing

### Test Type 1
```swift
Question(
  type: 1,
  text: "Pilih kata yang didengar",
  answerList: [
    Answer(text: "Dara", isCorrect: false),
    Answer(text: "Dasi", isCorrect: true)
  ]
)
```

### Test Type 2
```swift
Question(
  type: 2,
  text: "Ketik kata yang kamu dengar",
  answerList: [
    Answer(text: "Dasi", isCorrect: true)
  ]
)
```

## Migration Notes

### Existing Questions
- All existing questions default to Type 1
- No migration needed
- Backend can gradually add Type 2 questions

### Backward Compatibility
- Type 1 behavior unchanged
- New Type 2 only affects questions with `type: 2`
- Safe to deploy
