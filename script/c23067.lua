--厄运神✿键山雏
--require "expansions/nef/nef"
function c23067.initial_effect(c)
	--synchro summon
	Nef.AddSynchroProcedureWithDesc(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1,aux.Stringid(23067,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23067,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c23067.syncon)
	e1:SetOperation(c23067.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--extra to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23067,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCountLimit(1,23067)
	e2:SetCondition(c23067.con)
	e2:SetTarget(c23067.tg)
	e2:SetOperation(c23067.op)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23067,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23068)
	e3:SetTarget(c23067.target)
	e3:SetOperation(c23067.operation)
	c:RegisterEffect(e3)
end
function c23067.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and c:IsFaceup()
end
function c23067.matfilter2(c,syncard)	
	return c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x113)
end
function c23067.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	return g2:IsExists(c23067.synfilter3,1,nil,lv-tlv)
end
function c23067.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c23067.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c23067.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(c23067.matfilter2,tp,LOCATION_HAND,0,nil,c)
	local lv=c:GetLevel()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and g1:IsExists(c23067.synfilter1,1,nil,lv,g1,g2)
end
function c23067.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c23067.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(c23067.matfilter2,tp,LOCATION_HAND,0,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g1:FilterSelect(tp,c23067.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=g2:FilterSelect(tp,c23067.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c23067.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c23067.filter(c)
	return c:IsAbleToGrave() and c:GetLevel()<9 and c:GetRank()<9
end
function c23067.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23067.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_EXTRA)
end
function c23067.op(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	if cg:GetCount()>0 then Duel.ConfirmCards(tp,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23067.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c23067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_DECK)
end
function c23067.thfilter(c)
	return c:IsSetCard(0x382) and c:IsAbleToHand()
end
function c23067.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if g:IsExists(c23067.thfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c23067.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			g:RemoveCard(sg:GetFirst())
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
