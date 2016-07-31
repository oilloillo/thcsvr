--恶灵神✿键山雏
--require "expansions/nef/nef"
function c23064.initial_effect(c)
	--synchro summon
	Nef.AddSynchroProcedureWithDesc(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1,aux.Stringid(23064,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23064,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c23064.syncon)
	e1:SetOperation(c23064.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--extra to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23064,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,23064)
	e2:SetCondition(c23064.con)
	e2:SetTarget(c23064.tg)
	e2:SetOperation(c23064.op)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23064,3))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c23064.target)
	e3:SetOperation(c23064.operation)
	c:RegisterEffect(e3)
end
function c23064.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c23064.matfilter2(c,syncard)	
	return c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x113) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c23064.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	return g2:IsExists(c23064.synfilter3,1,nil,lv-tlv)
end
function c23064.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c23064.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c23064.matfilter1,tp,0x6,0,nil,c)
	local g2=Duel.GetMatchingGroup(c23064.matfilter2,tp,0x6,0,nil,c)
	local lv=c:GetLevel()
	local m=g1:FilterCount(Card.IsLocation,nil,LOCATION_HAND)+g2:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	if m > 2 then m = 2 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>m-2 and g1:IsExists(c23064.synfilter1,1,nil,lv,g1,g2)
end
function c23064.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c23064.matfilter1,tp,0x6,0,nil,c)
	local g2=Duel.GetMatchingGroup(c23064.matfilter2,tp,0x6,0,nil,c)
	local lv=c:GetLevel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		local g3=g1:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local g4=g2:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if g4:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local m3=g1:FilterSelect(tp,c23064.synfilter1,1,1,nil,lv,g1,g2)
			local mt1=m3:GetFirst()
			g:AddCard(mt1)
			local lv1=mt1:GetLevel()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			if mt1:IsLocation(LOCATION_MZONE) then
				local t1=g2:FilterSelect(tp,c23064.synfilter3,1,1,nil,lv-lv1)
				g:Merge(t1)	c:SetMaterial(g)
			else
				local t1=g4:FilterSelect(tp,c23064.synfilter3,1,1,nil,lv-lv1)
				g:Merge(t1)	c:SetMaterial(g)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local m3=g3:FilterSelect(tp,c23064.synfilter1,1,1,nil,lv,g1,g2)
			local mt1=m3:GetFirst()
			g:AddCard(mt1)
			local lv1=mt1:GetLevel()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local t1=g2:FilterSelect(tp,c23064.synfilter3,1,1,nil,lv-lv1)
			g:Merge(t1)	c:SetMaterial(g)
		end
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g1:FilterSelect(tp,c23064.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=g2:FilterSelect(tp,c23064.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c23064.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c23064.filter(c)
	return c:IsAbleToGrave() and c:GetLevel()<10 and c:GetRank()<10
end
function c23064.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23064.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c23064.op(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	if cg:GetCount()>0 then Duel.ConfirmCards(tp,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23064.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c23064.tgfilter(c)
	return not c:IsDisabled()
end
function c23064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c23064.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c23064.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c23064.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(0)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_TRIGGER)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(1)
		tc:RegisterEffect(e5)
	end
end
