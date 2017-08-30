 
--妖魔书-今昔百鬼拾遗
function c21470006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
--	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21470006.target)
	e1:SetOperation(c21470006.activate)
	c:RegisterEffect(e1)
end
function c21470006.tfilter(c,code)
	return c:GetOriginalCode()==code and c:IsSSetable()
end
function c21470006.filter(c,tp)
	local code=c:GetOriginalCode()
	return ((code>=21470012 and code<=21470016) or (code==21470102) or (code==21470999))
	--c:IsType(TYPE_TRAP) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x2742)
	and Duel.IsExistingMatchingCard(c21470006.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetOriginalCode())
end
function c21470006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c21470006.filter(chkc,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (e:GetHandler():IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>1))
		and Duel.IsExistingTarget(c21470006.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21470006.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c21470006.activate(e,tp,eg,ep,ev,re,r,rp)--[[
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,c21470006.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
	if sg:GetCount()>0 then Duel.SSet(tp,sg:GetFirst()) end]]
	
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local num=Duel.GetMatchingGroupCount(c21470006.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tc:GetOriginalCode())
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<num then num=Duel.GetLocationCount(tp,LOCATION_SZONE) end
	if num<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c21470006.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,num,num,nil,tc:GetOriginalCode())
	if g:GetCount()==0 then return end
	local sc=g:GetFirst()
	local count=0
	local deck=0
	while count<num do
		if sc:IsLocation(LOCATION_DECK) then deck=1 end
		Duel.SSet(tp,sc)
		count=count+1
		sc=g:GetNext()
	end
	Duel.ConfirmCards(1-tp,g)
	if deck==1 then Duel.ShuffleDeck(tp) end
	--Duel.Recover(tp,count*1000,REASON_EFFECT)
end
